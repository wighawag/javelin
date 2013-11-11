/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/



package javelin;

import massive.sys.cmd.Command;
import massive.sys.io.FileSys;
import massive.sys.io.File;

class SetupCommand extends Command{


    public function new(){
        super();
    }

    override public function execute() : Void{
        super.execute();

        var haxePathEnvironementVariableDefined : Bool = false;
        var haxePath = Sys.getEnv ("HAXEPATH");
        var javelinScriptFile : File;

        if (haxePath != null){
            haxePathEnvironementVariableDefined = true;
        }

		if (FileSys.isWindows) {
			if (haxePath == null || haxePath == "") {
				haxePath = "C:\\Motion-Twin\\haxe\\";
			}
            checkHaxePathExistence(haxePath, haxePathEnvironementVariableDefined);
	        javelinScriptFile = console.originalDir.resolveFile("javelin.bat");
            var dest = console.originalDir.resolveDirectory(haxePath);
            javelinScriptFile.copyInto(dest);
		} else {
            if (haxePath == null || haxePath == "") {
                haxePath = "/usr/lib/haxe";
            }
            checkHaxePathExistence(haxePath, haxePathEnvironementVariableDefined);
            javelinScriptFile = console.originalDir.resolveFile("javelin.sh");

            var dest = console.originalDir.resolveDirectory(haxePath);
            javelinScriptFile.copyInto(dest);
            var newPath =  dest.resolveFile("javelin.sh").nativePath;
			Sys.command ("chmod", [ "755", newPath]);

			Sys.command("ln -s " + newPath +" /usr/bin/javelin");
		}
        print("=> Done");
    }

    private function checkHaxePathExistence(haxePath : String, haxePathEnvironementVariableDefined : Bool) : Void{
        if(!FileSys.exists(haxePath)){
            var message = "Haxe Path " + haxePath + " does not exist";
            if (!haxePathEnvironementVariableDefined){
                message+="\n please define HAXEPATH environement variable to point to where Haxe is installed on your system";
            }else{
                message+="\n please check your HAXEPATH environement variable and where Haxe is installed on your system";
            }
            error(message);
        }
    }
}
