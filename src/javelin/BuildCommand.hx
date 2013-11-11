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

class BuildCommand extends TestCommand{

    private var skipBuild : Bool = false;
    public function new(){
        super();
    }

    override public function initialise():Void{
        super.initialise();
    }

    override public function execute() : Void{
        super.execute();
#if debug
        print("executing BuildCommand");
#end
        if(skipBuild){
            return;
        }
        var runCompileArgs = project.getRunHaxeArguments();
        if(runCompileArgs != null){
            var runFile = console.dir.resolveFile(MLibCommand.RUNFILE);
            var runFileExisted = runFile.exists;
            if(debug){
                runCompileArgs.push("-debug");
            }
            print("compiling : haxe " + runCompileArgs.join(" "));
            var runCompile = Sys.command("haxe", runCompileArgs);
            if(runCompile != 0){
                error("=> failed to compile run.n file");
            }else{
                if(!runFileExisted){
                    //set RUNFLIE to be deleted (if the process continue on Install)
                    pathsCreated.push(console.dir.resolveFile(MLibCommand.RUNFILE).nativePath);
                }
                print("=> run.n compiled!");
            }

        }
    }

}
