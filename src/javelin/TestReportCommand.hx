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

class TestReportCommand extends MunitCommand{

    public function new(){
        super();
    }

    override public function initialise():Void{
        super.initialise();
        #if debug
            print("initialising TestReportCommand");
        #end
    }


    override private function runMunit() : Int{
        var args = ["run", "munit", "report"];
        var i = 1;
        while(i<console.systemArgs.length-1){
            args.push(console.systemArgs[i]);
            i++;
        }
        return Sys.command("haxelib", args);
    }

}
