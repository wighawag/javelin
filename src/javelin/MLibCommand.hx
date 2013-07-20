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

class MLibCommand extends BuildCommand{

    inline public static var RUNFILE : String = "run.n";
    inline public static var LICENSE_FILE : String = "LICENSE.txt";
    public function new(){
        super();
    }

    override public function initialise():Void{
        super.initialise();
    }

    override public function execute() : Void{
        super.execute();
#if debug
        print("executing MLibCommand");
#end
        var mlibReturnCode = -1;
        try{
            var licenseFileName = project.licenseFile;
#if debug
            print("debug: " + "license file : "  + licenseFileName);
#end
            var defaultLicenseFile = console.dir.resolveFile(LICENSE_FILE);
            if(!defaultLicenseFile.exists){
                if(licenseFileName == null){
                    createFile(LICENSE_FILE);
                    licenseFileName = LICENSE_FILE;
                }else if(licenseFileName == LICENSE_FILE){
                    error("Cannot find " + LICENSE_FILE);
                }else{
                    pathsCreated.push(defaultLicenseFile.nativePath);
                }
            }else{
                if(licenseFileName == null){
                    licenseFileName = LICENSE_FILE;
                }else if(licenseFileName == LICENSE_FILE){
                    //nothing to do
                }else{
                    createFile(LICENSE_FILE);
                }
            }
#if debug
            print("debug : "+ "license file : " + licenseFileName);
#end
            if(licenseFileName != LICENSE_FILE){
                var licenseFile = console.dir.resolveFile(licenseFileName);
                if(!licenseFile.exists){
                    error("Cannot find " + licenseFileName);
                }
            }
            var mlibTemplate = new Template(Resource.getString("mlib.mtt"));
            var mlibContent = mlibTemplate.execute({
                licenseFile:licenseFileName,
                classPaths:[project.classPath],
                runFile:((project.runMain!=null && project.runMain != "")?RUNFILE:null),
                resources:project.resources,
                haxelibOutput:project.haxelibOutput}); 
            var mlibFile = createFile(".mlib");
            mlibFile.writeString(mlibContent, false);

#if debug
            print(mlibContent);
#end

            var deps : Array<Dependency> = null;
            if(console.getOption("nodeps") == 'true'){
                deps = [];
            }else{
                deps = project.dependencies;
            }

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
                dependencies:printDependencies(deps)
            });
            var haxelibFile = createFile("haxelib.json");
            haxelibFile.writeString(haxelibContent, false);
#if debug print(haxelibContent); #end
            mlibReturnCode = runMlib();
        }catch(e : Dynamic){
            print(e);
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

    private function printDependencies(arr : Array<Dependency>) : String{
        var str = "{}";
        if(arr.length > 0){
            str = "{";
            var counter = 0;
            while(counter < arr.length){
                var dependency = arr[counter];
                if(counter > 0){
                    str+=",";
                }
                var dependencyString = "\"" + dependency.name + "\"";
                if(dependency.version != null){
                    dependencyString += ":" + "\"" + dependency.version + "\"";
                }else{
                    dependencyString += ":" + "\"" +"\"";
                }
                str+=dependencyString;
                counter ++;
            }
            str+="}";
        }
        return str;
    }
}
