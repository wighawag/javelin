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

class MLibCommand extends TestCommand{

    public function new(){
        super();
    }

    override public function initialise():Void{
        super.initialise();
    }

    override public function execute() : Void{
        super.execute();

        var runFile : String = null;

        if(project.runMain != null && project.runMain != ""){
            runFile = "run.n";
            var runCompileArgs = ["-neko", runFile, "-main", project.runMain];
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
                print("=> run.n compiled!");
            }

        }

        var mlibReturnCode = -1;
        try{
            var mlibTemplate = new Template(Resource.getString("mlib.mtt"));
            var mlibContent = mlibTemplate.execute({licenseFile:project.licenseFile,classPaths:project.classPaths,runFile:runFile,resources:project.resources,haxelibOutput:project.haxelibOutput}); 
            var mlibFile = createFile(".mlib");
            mlibFile.writeString(mlibContent, false);


            var haxelibTemplate = new Template(Resource.getString("haxelib.json.mtt"));
            var haxelibContent = haxelibTemplate.execute({
                name:project.name,
                version:project.version,
                url:project.url,
                license:project.license,
                tags:printArray(project.tags),
                description:project.description,
                releaseNotes:project.releaseNotes,
                contributors:printArray(project.contributors),
                dependencies:printDependencies(project.dependencies),
            });
            var haxelibFile = createFile("haxelib.json");
            haxelibFile.writeString(haxelibContent, false);
            mlibReturnCode = runMlib();
        }catch(e : Dynamic){
            print(e);
        }

        if(runFile != null){
            var runNFile = console.dir.resolveFile(runFile);
            runNFile.deleteFile();
        }
        if(doNotDeleteFileOnError && mlibReturnCode != 0){
            print("keep file for investigation");
        }else{
            deleteFiles();
        }


        if(mlibReturnCode != 0){
            error("=> Failure");
        }else{
            print("=> Success");
        }

    }

    private function runMlib() : Int{
        return 0;
    }

    private function printArray(arr : Array<String>) : String{
        var str = "[]";
        if(arr.length > 0){
            str = "[\"" + arr.join("\",\"") + "\"]";
        }
        return str;
    }

    private function printDependencies(arr : Array<{name:String,version:String}>) : String{
        var str = "{}";
        if(arr.length > 0){
            str = "{";
            var counter = 0;
            while(counter < arr.length){
                var dependency = arr[counter];
                if(counter > 0){
                    str+=",";
                }
                str+="\"" + dependency.name + "\":\"" + dependency.version + "\"";
                counter ++;
            }
            str+="}";
        }
        return str;
    }
}
