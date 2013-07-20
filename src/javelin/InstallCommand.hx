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

class InstallCommand extends MLibCommand{

    public function new(){
        super();
    }

    override public function initialise():Void{
        super.initialise();
        #if debug
            print("initialising InstallCommand");
        #end
    }


    override private function runMlib() : Int{
        return Sys.command("haxelib", ["run", "wighawag-mlib", "install"]);
    }

}
