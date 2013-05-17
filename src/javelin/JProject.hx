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
    public var dependencies : Array<{name:String,version:String}>;
    public var classPaths : Array<String>;
    public var targets : Array<String>;
    public var runMain : String;
    public var runDependencies : Array<{name:String,version:String}>;
    public var runClassPaths : Array<String>;
    public var runCompileTimeResources : Array<String>;
    public var resources : Array<{path:String,dest:String}>;
    public var testSources : String;
    public var testReport : String;
    public var testBuild : String;
    public var haxelibOutput : String;
    

    private var data : Dynamic;

    public function new(json : String, haxelibProject : Bool){
        this.haxelibProject = haxelibProject;
        data = Json.parse(json);

        // Haxelib subset :
        name = need("name");
        version = need("version");
        url = need("url");
        license = need("license");
        tags = needArray("tags");
        description = need("description");
        contributors = needArray("contributors");

        dependencies = needDependencies("dependencies"); 

        //Javelin specific 
        var defaultSource = "src";
        if(haxelibProject){
            defaultSource = "./";
        }
        licenseFile = get("licenseFile","");
        classPaths = getArray("classPaths", [defaultSource]);
        targets = getArray("targets", []);
        runMain = get("runMain", null);
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
    }

    private function needDependencies(fieldName : String) : Array<{name:String,version:String}>{
        var dependencies = getDependencies(fieldName, null);
        if(dependencies == null){
            throw "javelin project file need field '"+ fieldName +"'";
        }
        return dependencies;
    }

    private function getDependencies(fieldName : String, ?defaultValue :  Array<{name:String,version:String}> = null) : Array<{name:String,version:String}>{
        var dependencies : Array<{name : String, version : String}> = new Array();
        var field = Reflect.field(data,fieldName);
        for (dependency in Reflect.fields(field)){
            var version = Reflect.field(field, dependency);
            dependencies.push({name:dependency,version:version});
        }
        return dependencies;
    }

    private function need(fieldName : String) : String{
        var value = get(fieldName);
        if(value == null){
            throw "javaline project file need field '" + fieldName + "' as a String";
        }
        return value;
    }

    private function get(fieldName : String, ?defaultValue : String = null) : String{
        var value : String = cast(Reflect.field(data,fieldName));
        if (value == null){
            value = defaultValue;
        }
        return value;
    }

    private function getArray(fieldName : String, ?defaultValue : Array<String>= null) : Array<String>{
        var arrayValue : Array<String> = cast(Reflect.field(data, fieldName));
        if(arrayValue == null){
            arrayValue = defaultValue;
        }
        return arrayValue;
    }

    private function needArray(fieldName : String) : Array<String>{
        var arrayValue = getArray(fieldName, null);
        if(arrayValue == null){
             throw "javaline project file need field '" + fieldName + "' as a Array of String";
        }
        return arrayValue;
    }

}
