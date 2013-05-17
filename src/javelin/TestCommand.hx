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

class TestCommand extends JCommand{

    public function new(){
        super();
    }

    override public function execute() : Void{
        super.execute();
        var testHxml = "test.hxml";
        var munitTemplate = new Template(Resource.getString("munit.mtt"));
        var munitContent = munitTemplate.execute({version:project.version,classPaths:project.classPaths,testBuild:project.testBuild,testSources:project.testSources,testHxml:testHxml, testReport:project.testReport});
        var munitFile = createFile(".munit");
        munitFile.writeString(munitContent, false);

        var dependencies = new Array<String>();
        for (dependency in project.dependencies){
            var dependencyString = dependency.name;
            if(dependency.version != null && dependency.version != "" && dependency.version != "*"){
                dependencyString +=":"+dependency.version;
            }
            dependencies.push(dependencyString);
        }
        var testHxmlTemplate = new Template(Resource.getString("test.hxml.mtt"));
        var testHxmlContent = testHxmlTemplate.execute({classPaths:project.classPaths,dependencies:dependencies,targets:project.targets,testSources:project.testSources,testBuild:project.testBuild});
        var testHxmlFile = createFile(testHxml);
        testHxmlFile.writeString(testHxmlContent, false);

        var args = ["run", "munit", "test", "-kill-browser"];
        for (target in project.targets){
            args.push("-" + target);
        }

        var munitReturnCode = Sys.command("haxelib", args);

        deleteFiles();

        if(munitReturnCode != 0){
            error("=> Test Failed");
        }else{
            print("=> Test Passed");
        }
    }
}
