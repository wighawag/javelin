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


    private var debug : Bool = false;
    private var skipTest : Bool = false;
    private var doNotDeleteFileOnError : Bool = false;

    public function new(){
        super();
    }

    override public function initialise() : Void{
        super.initialise();
        #if debug
            print("initialising TestCommand");
        #end
        debug = console.getOption("debug") == 'true';
        skipTest = (console.getOption("skipTest") == 'true');
        doNotDeleteFileOnError = (console.getOption("noDeleteOnError") == 'true');
    }

    override public function execute() : Void{
        super.execute();
        if(skipTest){
            return;
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

        var munitReturnCode = -1;
        try{
            var extra = "";
            if(debug){
                extra = "-debug";
            }
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
            for (dependency in project.testExtraDependencies){
                var dependencyString = dependency.name;
                if(dependency.version != null && dependency.version != "" && dependency.version != "*"){
                    dependencyString +=":"+dependency.version;
                }
                dependencies.push(dependencyString);
            }
            var testHxmlTemplate = new Template(Resource.getString("test.hxml.mtt"));
            var testHxmlContent = testHxmlTemplate.execute({classPaths:project.classPaths,dependencies:dependencies,targets:project.targets,testSources:project.testSources,testBuild:project.testBuild,extra:extra});
            var testHxmlFile = createFile(testHxml);
            testHxmlFile.writeString(testHxmlContent, false);

            var args = ["run", "munit", "test", "-kill-browser"];
            for (target in project.targets){
                args.push("-" + target);
            }

            munitReturnCode = Sys.command("haxelib", args);
        }catch(e : Dynamic){
            print(e);
        }
        if(doNotDeleteFileOnError && munitReturnCode != 0){
            print("keep file for investigation");
        }else{
            deleteFiles();
            testMainFile.deleteFile();
            testSuiteFile.deleteFile();
            exampleTestFile.deleteFile();
        }

        if(munitReturnCode != 0){
            error("=> Failure");
        }else{
            print("=> Success");
        }
    }
}
