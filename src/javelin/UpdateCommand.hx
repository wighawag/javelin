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

class UpdateCommand extends JCommand{

    public function new(){
        super();
    }

    override public function initialise():Void{
        super.initialise();
    }

    override public function execute() : Void{
        super.execute();
#if debug
        print("executing UpdateCommand");
#end
        var runHxmlFile = console.dir.resolveFile("run.hxml");
        var args = project.getRunHaxeArguments();
        runHxmlFile.writeString(args.join("\n"));
        print("=> Success");
    }

}
