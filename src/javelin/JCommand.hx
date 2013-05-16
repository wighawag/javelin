package javelin;

import massive.sys.cmd.Command;
import massive.sys.io.File;
import haxe.ds.StringMap;

class JCommand extends Command{

    private var project : JProject;

    private var tmpFiles : StringMap<File>;

    public function new(){
        super();
        tmpFiles = new StringMap();
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
        project = new JProject(content, haxelibFile);
    }

    private function createFile(path : String, ?keep : Bool = true) : File{
        var file = console.dir.resolveFile(path);
        if(file.exists){
            if(keep){
                var tmpFile = File.createTempFile();
                tmpFiles.set(path,tmpFile);
                file.copyTo(tmpFile, true);
            }
            file.writeString(""); //emtpy the file
        }else{
            file.createFile();
        }
        return file;
    }

    private function deleteFiles() : Void{
        for(path in tmpFiles.keys()){
            deleteFile(path, false);
        }
        tmpFiles = new StringMap();
    }

    private function deleteFile(path : String, ?removeFromMap : Bool = true) : Void{
        var file = console.dir.resolveFile(path);
        var tmpFile = tmpFiles.get(path);
        if(tmpFile != null){
            tmpFile.moveTo(file, true);
        }else{
            file.deleteFile();
        }
        if(removeFromMap){
            tmpFiles.remove(path);
        }
    }

}
