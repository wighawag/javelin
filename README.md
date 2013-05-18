javelin's goal is to provide a safe and fast way to manage your own haxelib library without duplicating information.

- safe as there is only one command to run : ```javelin deploy``` that will test before deploying.
- fast as it is only one command to install locally ```javelin install``` 
- avoid duplication by only needing one file : "haxelib.json"

The javelin project/libary format is a superset of haxelib format and thus an haxelib is already a valid javelin project.

For every extra field that javlin suport there is a default to keep compatibility with haxelib format.

For example the test folder is by default "test"
Since haxelib use the current directory as the default source folder, javelin might use another test folder, maybe with an hyphen to avoid conflict with potential package name.


Internally javelin use https://github.com/massiveinteractive/MassiveUnit and https://github.com/massiveinteractive/MassiveLib but javelin do not require you to write these two tool own config file. It does that by generating these config files from haxelib.json.

javelin also allow you to generate file from template. This allow you to work with non library project. 
For example you can setup a nmml template (javelin migth be able to generate one in the future) and then javelin can fill teh values in. 

This way, if you want to upgrade a lib version or add another dependenices. you just need to do ```javelin update``` and javelin will rebuild the nmml file so taht  you can compile with the new set of dependencies. 

Also since javelin support haxelib, if your lib is on a git repo, it can still be used as an haxelib.


javelin is still a Work in Progress and require a modified version of mlib that is not actually working completely (need to wait for a mlib that support new haxelib json format)



