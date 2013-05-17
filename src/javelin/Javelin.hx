/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package javelin;
import massive.sys.cmd.CommandLineRunner;

class Javelin extends CommandLineRunner {

    static public function main():Javelin{return new Javelin();}

    public function new(){
        super();

        mapCommand(SetupCommand, "setup", [], "add javelin as command, require root access");
        mapCommand(TestCommand, "test", ["t"], "test the project");
        mapCommand(InstallCommand, "install", ["i"], "install the project locally");
        mapCommand(DeployCommand, "deploy", [], "deploy to haxelib");
        run();

    }

    override function printHeader():Void{
        var year = VersionMacro.getFullYear(); 
        var version = VersionMacro.getVersion();
        print('Javelin $version - Copyright $year Wighawag'); 
    }

}
