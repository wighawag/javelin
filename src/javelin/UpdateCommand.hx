/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/



package javelin;
import massive.sys.io.File;
import sys.io.Process;
import haxe.Template;
import haxe.Resource;
import massive.sys.haxelib.HaxelibTools;
using javelin.DependencyUtils;

class UpdateCommand extends JCommand{

    public function new(){
        super();
    }

    override public function initialise():Void{
        super.initialise();
    }

    override public function execute() : Void{
        super.execute();
#if debug
        print("executing UpdateCommand");
#end
        var args = project.getRunHaxeArguments();
        if(args != null){
            print("updating run.hxml");
            var runHxmlFile = console.dir.resolveFile("run.hxml");
            runHxmlFile.writeString(args.join("\n"));
        }

        print("updating dependencies");
        var allDependencies=mergeDependencies([project.dependencies, project.runDependencies, project.testExtraDependencies]);
        for(dependency in allDependencies){
            if(!HaxelibTools.isLibraryInstalled(dependency.name, dependency.version)){
                print("installing " + dependency.toString() + "...");
                HaxelibTools.install(dependency.name, dependency.version);
            }
        }
        print("=> Success");
    }

    private function mergeDependencies(dependencies : Array<Array<Dependency>>) : Array<Dependency>{
        var mergedDependencies = new Array<Dependency>();
        for(depList in dependencies){
            for(dep in depList){
                if(!containsDependency(mergedDependencies,dep)){
                    mergedDependencies.push(dep);
                }
            }
        }
        return mergedDependencies;
    }

    private function containsDependency(dependencies : Array<Dependency>, dependency:Dependency) : Bool{
        for(dep in dependencies){
            if(dep.name == dependency.name && dep.version == dependency.version){
                return true;
            }
        }
        return false;
    }

}
