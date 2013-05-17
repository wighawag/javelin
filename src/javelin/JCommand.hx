/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package javelin;

import massive.sys.cmd.Command;
import massive.sys.io.File;
import haxe.ds.StringMap;

class JCommand extends Command{

    private var project : JProject;

    private var tmpFiles : StringMap<File>;
    private var pathsCreated : Array<String>;

    public function new(){
        super();
        tmpFiles = new StringMap();
        pathsCreated = new Array();
    }

    override public function execute() : Void{
        super.execute();

        var haxelibFile : Bool = false;
        var javelinFile = console.dir.resolveFile("javelin.json");
        if(!javelinFile.exists){
            javelinFile = console.dir.resolveFile("haxelib.json");
            if(!javelinFile.exists){
                error("=> need a javelin project file in the current directory (can be either a javelin.json or a normal haxelib.json");
            }
            print("=> using haxelib.json");
            haxelibFile = true;
        }
        var content = javelinFile.readString();
        try{
            project = new JProject(content, haxelibFile);
        }catch(e:Dynamic){
            error("Error parsing javelin project file (" + javelinFile.path + ") : " + e);
        }
    }

    private function createFile(path : String, ?keepExisting : Bool = true) : File{
        var file = console.dir.resolveFile(path);
        if(file.exists){
            if(keepExisting){
                var tmpFile = File.createTempFile();
                tmpFiles.set(path,tmpFile);
                file.copyTo(tmpFile, true);
            }
            file.writeString(""); //emtpy the file
        }else{
            file.createFile();
        }
        pathsCreated.push(path);
        return file;
    }

    private function deleteFiles() : Void{
        while(pathsCreated.length>0){
            deleteFile(pathsCreated.pop());
        }
    }

    private function deleteFile(path : String) : Void{
        var file = console.dir.resolveFile(path);
        var tmpFile = tmpFiles.get(path);
        if(tmpFile != null){
            tmpFile.moveTo(file, true);
        }else{
            file.deleteFile();
        }
        tmpFiles.remove(path);
    }

}
