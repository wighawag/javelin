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

class MunitCommand extends UpdateCommand{

    public function new(){
        super();
    }

    override public function execute() : Void{
        super.execute();

        var munitReturnCode = -1;
        try{
            var testHxml = "test.hxml";
            var munitTemplate = new Template(Resource.getString("munit.mtt"));
            var munitContent = munitTemplate.execute({version:project.version,classPaths:[project.classPath],testBuild:project.testBuild,testSources:project.testSources,testHxml:testHxml, testReport:project.testReport});
            var munitFile = createFile(".munit");
            munitFile.writeString(munitContent, false);
            munitReturnCode = runMunit();
       }catch(e : Dynamic){
            print(e);
        }
        if(doNotDeleteFileOnError && munitReturnCode != 0){
            print("keep file for investigation");
        }else{
            deleteFiles();
        }

        if(munitReturnCode != 0){
            error("=> Failure");
        }else{
            print("=> Success");
        }
    }

    private function runMunit() : Int{
        return 0;
    }
}
