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
        var munitTemplate = new Template(Resource.getString("munit.mtt"));
        var munitContent = munitTemplate.execute({version:project.version,classPaths:project.classPaths});
        var munitFile = File.create(".munit",console.dir,true);
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
        var testHxmlContent = testHxmlTemplate.execute({classPaths:project.classPaths,dependencies:dependencies,targets:project.targets});
        var testHxmlFile = File.create("test.hxml", console.dir, true);//TODO test.hxml should be extracted from .munit?
        testHxmlFile.writeString(testHxmlContent, false);

        var args = ["run", "munit", "test", "-kill-browser"];
        for (target in project.targets){
            args.push("-" + target);
        }

        var munitReturnCode = Sys.command("haxelib", args);
        if(munitReturnCode != 0){
            error("=> Test Failed");
        }else{
            print("=> Test Passed");
        }
    }
}
