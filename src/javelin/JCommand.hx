package javelin;

import massive.sys.cmd.Command;

class JCommand extends Command{

    private var project : JProject;
    public function new(){
        super();
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

}
