package javelin;
import massive.sys.cmd.CommandLineRunner;

class Javelin extends CommandLineRunner {

    static public function main():Javelin{return new Javelin();}

    public function new(){
        super();

        mapCommand(TestCommand, "test", ["t"], "test the project");
        mapCommand(InstallCommand, "install", ["i"], "install the project locally");

        run();

    }

    override function printHeader():Void{
        print("Javelin - Copyright 2013 Wighawag"); 
    }

}
