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

class InstallCommand extends JCommand{

    public function new(){
        super();
        addPreRequisite(TestCommand);

    }

    override public function execute() : Void{
        super.execute();

        var runFile : String = null;

        if(project.runMain != null && project.runMain != ""){
            print("compiling " + project.runMain + " in run.n");
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
            print("compiling : haxe " + runCompileArgs.join(" "));
            var runCompile = Sys.command("haxe", runCompileArgs);
            if(runCompile != 0){
                error("=> failed to compile run.n file");
            }else{
                print("=> run.n compiled!");
            }

        }

        var mlibTemplate = new Template(Resource.getString("mlib.mtt"));
        var mlibContent = mlibTemplate.execute({licenseFile:project.licenseFile,classPaths:project.classPaths,runFile:runFile,resources:project.resources,haxelibOutput:project.haxelibOutput}); //TODO add resources ?
        var mlibFile = createFile(".mlib");
        mlibFile.writeString(mlibContent, false);

        var releaseNotes = console.prompt("release notes", 2);//TODO get rid for local install

        var haxelibTemplate = new Template(Resource.getString("haxelib.json.mtt"));
        var haxelibContent = haxelibTemplate.execute({
            name:project.name,
            url:project.url,
            license:project.license,
            tags:printArray(project.tags),
            description:project.description,
            releaseNotes:releaseNotes,
            contributors:printArray(project.contributors),
            dependencies:printDependencies(project.dependencies),
        });
        var haxelibFile = createFile("haxelib.json");
        haxelibFile.writeString(haxelibContent, false);

        var mlibReturnCode = Sys.command("haxelib", ["run", "mlib", "install"]);

        deleteFiles();

        if(mlibReturnCode != 0){
            error("=> Failed to install");
        }

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
