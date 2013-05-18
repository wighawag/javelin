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

class InstallCommand extends MLibCommand{

    public function new(){
        super();
    }

    override public function initialise():Void{
        super.initialise();
        #if debug
            print("initialising InstallCommand");
        #end
    }


    override private function runMlib() : Int{
        if(project.runMain != null && project.runMain != ""){
            var runCompileArgs = ["-neko", MLibCommand.RUNFILE, "-main", project.runMain];
            for(runClassPath in project.runClassPaths){
                runCompileArgs.push("-cp");
                runCompileArgs.push(runClassPath);
            }
            for(runDependency in project.runDependencies){
                runCompileArgs.push("-lib");
                if(runDependency.version !=null && runDependency.version != "" && runDependency.version != "*"){
                    runCompileArgs.push(runDependency.name + ":" + runDependency.version);
                }else{
                    runCompileArgs.push(runDependency.name);
                }
            }
            for(runCompileTimeResource in project.runCompileTimeResources){
                runCompileArgs.push("-resource");
                runCompileArgs.push(runCompileTimeResource + "@" + runCompileTimeResource);
            }
            if(debug){
                runCompileArgs.push("-debug");
            }
            print("compiling : haxe " + runCompileArgs.join(" "));
            var runCompile = Sys.command("haxe", runCompileArgs);
            if(runCompile != 0){
                error("=> failed to compile run.n file");
            }else{
                pathsCreated.push(console.dir.resolveFile(MLibCommand.RUNFILE).nativePath);
                print("=> run.n compiled!");
            }

        }


        return Sys.command("haxelib", ["run", "mlib", "install"]);
    }

}
