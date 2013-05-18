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

        mapCommand(UpdateCommand, "update", ["u"], "update the project/template files and make sure dependencies are installed (WIP)");
        mapCommand(TestCommand, "test", ["t"], "test the project");
        mapCommand(BuildCommand, "build", ["b"], "build the run file if any");
        mapCommand(InstallCommand, "install", ["i"], "install the project locally");
        mapCommand(DeployCommand, "deploy", [], "deploy to haxelib");

        mapCommand(CreateTestCommand, "createTest", ["ct"], "call munit to generate test (call 'munit help create' for help)");
        mapCommand(TestReportCommand,"report",["r"], "call munit to get a test report (call 'munit help report' for help)");
        mapCommand(LicenseCommand, "license", ["l"], "call mlib to add license test (call 'mlib help license' for help)");
        //TODO (check with mlib for haxelib v2) mapCommand(IncrementVersionCommand, "incrementVersion", ["v"], "call mlib to increment version (call 'mlib help incrementVersion' for help)");

        run();

    }

    override function printHeader():Void{
        var year = VersionMacro.getFullYear(); 
        var version = VersionMacro.getVersion();
        print('Javelin $version - Copyright $year Wighawag'); 
    }

}
