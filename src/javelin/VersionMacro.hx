/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package javelin;
import haxe.macro.Context;
import massive.sys.io.File;

class VersionMacro{

    macro public static function getFullYear(){
        var date = Std.string(Date.now().getFullYear());
        var pos = Context.currentPos();
        return macro $v{date};
    }

    macro public static function getVersion(){
        //TODO remove duplication with JCommand.hx
        var haxelibProjectFile = false;
        var javelinProjectFile = File.current.resolveFile("javelin.json");
        if(!javelinProjectFile.exists){
            javelinProjectFile = File.current.resolveFile("haxelib.json");
            if(!javelinProjectFile.exists){
                Context.error("no project file found", Context.currentPos());
            }
            haxelibProjectFile = true;
        }
        var project = new JProject(javelinProjectFile.readString(), haxelibProjectFile);

        return macro $v{project.version};
    }

}
