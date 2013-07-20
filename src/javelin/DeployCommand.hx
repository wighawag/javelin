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

class DeployCommand extends InstallCommand{


    public function new(){
        super();
    }

    override public function initialise():Void{
        super.initialise();
        #if debug
            print("initialising DeployCommand");
        #end
        if(console.getOption("debug") == 'true'){
            error("cannot deploy in debug mode ");
        }
        project.releaseNotes = console.prompt("release notes", 2);

    }

    override public function execute() : Void{
        super.execute();
    }

    override private function runMlib():Int{
        var code = super.runMlib();
        if(code != 0){
            return code;
        }
        return Sys.command("haxelib", ["run", "wighawag-mlib", "submit"]);
    }
}
