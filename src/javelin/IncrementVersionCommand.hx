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

class IncrementVersionCommand extends MLibCommand{

    public function new(){
        super();
    }

    override public function initialise():Void{
        super.initialise();
        #if debug
            print("initialising IncrementVersionCommand");
        #end
        skipTest = true;
    }


    override private function runMlib() : Int{
        var args = ["run", "mlib", "incrementVersion"];
        var i = 1;
        while(i<console.systemArgs.length-1){
            args.push(console.systemArgs[i]);
            i++;
        }
        return Sys.command("haxelib", args);
    }

}
