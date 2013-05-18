/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package javelin;

class DependencyUtils{

    public static function toString(dependency : Dependency) : String{
        var dependencyString = dependency.name;
        if(dependency.version != null){
            dependencyString += ":" + dependency.version;
        }
        return dependencyString;
    }
}
