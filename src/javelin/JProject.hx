/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package javelin;
import haxe.Json;
import haxe.ds.StringMap;

class JProject{

    public var haxelibProject : Bool;

    public var name : String;
    public var version : String;
    public var url : String;
    public var license : String;
    public var licenseFile : String;
    public var mainClass : String;
    public var tags : Array<String>;
    public var description : String;
    public var contributors : Array<String>;
    public var dependencies : Array<Dependency>;
    public var classPath : String;
    public var targets : Array<String>;
    public var runMain : String;
    public var runDependencies : Array<Dependency>;
    public var runClassPaths : Array<String>;
    public var runCompileTimeResources : Array<String>;
    public var resources : Array<{path:String,dest:String}>;
    public var testSources : String;
    public var testReport : String;
    public var testBuild : String;
    public var haxelibOutput : String;
    public var testExtraDependencies : Array<Dependency>;
    public var releaseNotes = "";
    public var extraCompileParams : Array<String>;

    private var data : Dynamic;

    public function new(json : String, haxelibProject : Bool){
        this.haxelibProject = haxelibProject;
        data = Json.parse(json);

        // Haxelib subset :
        name = get("name");
        version = get("version");
        url = get("url");
        license = get("license");
        tags = getArray("tags");
        description = get("description");
        contributors = getArray("contributors");

        dependencies = needDependencies("dependencies"); 

        //Javelin specific 
        var defaultSource = "src";
        if(haxelibProject){
            defaultSource = "./";
        }
        licenseFile = get("licenseFile",null, true);
        classPath = get("classPath", defaultSource);
        targets = getArray("targets", []);
        runMain = get("runMain", "");
        runDependencies = getDependencies("runDependencies",[]);
        runClassPaths = getArray("runClassPaths", [defaultSource]);
        runCompileTimeResources = getArray("runCompileTimeResources",[]);

        resources = new Array();
        if(Reflect.hasField(data,"resources")){
            for(resource in Reflect.fields(data.resources)){
                var dest : String = Reflect.field(data.resources, resource);
                resources.push({path:resource,dest:dest});
            }
        }

        testSources = get("testSources","test");
        testReport = get("testReport", "test-report");
        testBuild = get("testBuild", "test-build");
        haxelibOutput = get("haxelibOutput","haxelib");
        testExtraDependencies = getDependencies("testExtraDependencies",[]);

        extraCompileParams = getArray("extraCompileParams",[]);
    }

    private function needDependencies(fieldName : String) : Array<Dependency>{
        var dependencies = getDependencies(fieldName, null);
        if(dependencies == null){
            throw "javelin project file need field '"+ fieldName +"'";
        }
        return dependencies;
    }

    private function getDependencies(fieldName : String, ?defaultValue :  Array<Dependency> = null) : Array<Dependency>{
        var dependencies = new Array<Dependency>();
        var field = Reflect.field(data,fieldName);
        for (dependency in Reflect.fields(field)){
            var version = Reflect.field(field, dependency);
            if(version == "*" || version == ""){
                version = null;
            }
            dependencies.push({name:dependency,version:version});
        }
        return dependencies;
    }


    private function get(fieldName : String, ?defaultValue : String = null, ?allowNull=false) : String{
        var value : String = cast(Reflect.field(data,fieldName));
        if (value == null){
            value = defaultValue;
        }
        if(value == null && !allowNull){
            throw "javaline project file need field '" + fieldName + "' as a String";
        }
        return value;
    }

    private function getArray(fieldName : String, ?defaultValue : Array<String>= null) : Array<String>{
        var arrayValue : Array<String> = cast(Reflect.field(data, fieldName));
        if(arrayValue == null){
            arrayValue = defaultValue;
        }
        if(arrayValue == null){
             throw "javaline project file need field '" + fieldName + "' as a Array of String";
        }
        return arrayValue;
    }

    public function toString() : String{
        return 'Javelin' + "\n"
            + 'haxelib file: $haxelibProject' + "\n"
            + 'name: $name' + "\n"
            + 'version: $version' + "\n"
            + 'url: $url' + "\n"
            + 'license: $license' + "\n"
            + 'licenseFile: $licenseFile' + "\n"
            + 'mainClass: $mainClass' + "\n"
            + 'tags: $tags' + "\n"
            + 'description: $description' + "\n"
            + 'contributors: $contributors' + "\n"
            + 'dependencies: $dependencies' + "\n"
            + 'classPath: $classPath' + "\n"
            + 'targets: $targets' + "\n"
            + 'runMain: $runMain' + "\n"
            + 'runDependencies: $runDependencies' + "\n"
            + 'runClassPaths: $runClassPaths' + "\n"
            + 'runCompileTimeResources: $runCompileTimeResources' + "\n"
            + 'resources: $resources' + "\n"
            + 'testSources: $testSources' + "\n"
            + 'testReport: $testReport' + "\n"
            + 'testBuild: $testBuild' + "\n"
            + 'haxelibOutput: $haxelibOutput' + "\n"
            + 'testExtraDependencies: $testExtraDependencies' + "\n"
            + 'releaseNotes: $releaseNotes' + "\n";
    }

    public function getRunHaxeArguments() : Array<String>{
        if(runMain != null && runMain != ""){
            var runCompileArgs = ["-neko", MLibCommand.RUNFILE, "-main", runMain];
            for(runClassPath in runClassPaths){
                runCompileArgs.push("-cp");
                runCompileArgs.push(runClassPath);
            }
            for(runDependency in runDependencies){
                runCompileArgs.push("-lib");
                if(runDependency.version !=null && runDependency.version != "" && runDependency.version != "*"){
                    runCompileArgs.push(runDependency.name + ":" + runDependency.version);
                }else{
                    runCompileArgs.push(runDependency.name);
                }
            }
            for(runCompileTimeResource in runCompileTimeResources){
                runCompileArgs.push("-resource");
                runCompileArgs.push(runCompileTimeResource + "@" + runCompileTimeResource);
            }
           return runCompileArgs;
        }else{
            return null;
        }
    }

}
