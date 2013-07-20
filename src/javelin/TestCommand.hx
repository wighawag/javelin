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

class TestCommand extends MunitCommand{


    private var skipTest : Bool = false;

    public function new(){
        super();
    }

    override public function initialise() : Void{
        super.initialise();
        #if debug
            print("initialising TestCommand");
        #end
        skipTest = (console.getOption("skipTest") == 'true');
    }

    override function runMunit() : Int{
        if(skipTest){
            return 0;
        }

        var testSourcesDirectory = console.dir.resolveDirectory(project.testSources);
        if (!testSourcesDirectory.exists){
            error("test folder : " + project.testSources + " does not exist");
        }

        var testMainFile = testSourcesDirectory.resolveFile("TestMain.hx");
        if(testMainFile.exists){
            error("To be able to run the tests, TestMain.hx need to be created, but there is already a file of this name in the test folder :" + testMainFile.nativePath);
        }
        var testSuiteFile = testSourcesDirectory.resolveFile("TestSuite.hx");
        if(testMainFile.exists){
            error("To be able to run the tests, TestSuite.hx need to be created, but there is already a file of this name in the test folder :" + testSuiteFile.nativePath);
        }
        // will remove the ExampleTest.hx only if it did not exist before
        var exampleTestFile = testSourcesDirectory.resolveFile("ExampleTest.hx");
        if(exampleTestFile.exists){
            error("ExampleTest.hx cannot be the qualified class name of a test. Munit, the test runner will overwrite if allowed");
        }

        // set for deletion:
        pathsCreated.push(testMainFile.nativePath);
        pathsCreated.push(testSuiteFile.nativePath);
        pathsCreated.push(exampleTestFile.nativePath);

        var extra : Array<String> = project.extraCompileParams.copy();
        if(debug){
            extra.push("-debug");
        }
        var testHxml = "test.hxml";

        var dependencies =new Array<String>();
        for (dependency in project.dependencies){
            var dependencyString = dependency.name;
            if(dependency.version != null && dependency.version != "" && dependency.version != "*"){
                dependencyString +=":"+dependency.version;
            }
            dependencies.push(dependencyString);
        }
        for (dependency in project.testExtraDependencies){
            var dependencyString = dependency.name;
            if(dependency.version != null && dependency.version != "" && dependency.version != "*"){
                dependencyString +=":"+dependency.version;
            }
            dependencies.push(dependencyString);
        }
        var testHxmlTemplate = new Template(Resource.getString("test.hxml.mtt"));
        var testHxmlContent = testHxmlTemplate.execute({classPaths:[project.classPath],dependencies:dependencies,targets:project.targets,testSources:project.testSources,testBuild:project.testBuild,extraCompileParams:extra});
        var testHxmlFile = createFile(testHxml);
        testHxmlFile.writeString(testHxmlContent, false);

        var args = ["run", "munit", "test","-result-exit-code", "-kill-browser"];
        for (target in project.targets){
            args.push("-" + target);
        }

        return Sys.command("haxelib", args);

    }
}
