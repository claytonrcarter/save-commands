# Save-commands package for Atom editor

This package allows you to define parametrized shell commands
to be automatically run, in sequence, whenever a file matching glob pattern is saved.  
This effectively eliminates the need for file watchers, and simplifies your build process.
You can define as many globs and commands as you want.
The command(s) and their output will be displayed in a panel at the bottom of the screen. Hit 'Esc' to dismiss the panel.

### How to use

Create save-commands.json file in your project's root folder
Create one entry for each command you wish to run, and assign it to a glob like this:  
`"glob : command {parameter}"`  
or like this:  
`[ "glob", "command {parameter}" ]`  
See the optional Javascript configuration file information below for how to 
use a callback to generate the command to be run.

Here is an example of save-commands.json file
```
{
	"commands": [
		"*.coffee : coffee -c {relFullPath}",
		"src/**/*.coffee : coffee -c -o dist{relPathNoRoot} {relFullPath}",
		"src/**/client/**/*.coffee : gulp browserify",
		"src/client/**/*.jade   : jade -P {relPath}{filename} -o dist{relPathNoRoot}",
		"src/client/**/*.jade   : gulp createTemplateCache",
		"src/server/**/*.jade : copy {relPath}{filename} dist{relPathNoRoot}",
		"src/**/*.styl   : gulp compileStylus",
		"src/**/*-spec.coffee : mocha src{relPathNoRoot}{name}.coffee --compilers coffee:coffee-script/register",
		"src/**/*.coffee : gulp runSpec --file=src{relPathNoRoot}{name}-spec.coffee --require coffee-script/register --compilers coffee:coffee-script/register"
	]
}
```
You can create multiple save-commands.json files in various folders. The package will navigate file system tree
(starting with the folder where saved file is located) until it finds a config file. That folder will also
be used as current working directory for commands

If you get errors when saving a file, double check your save-commands.json file to make sure it is formatted properly. As of version 0.6.7, the package will warn you if config file is malformed.

If you store your commands in a Javascript file named `save-commands.js` (instead of using the normal JSON format), you can specify a callback to
generate the command on each save.  Here is an example of a `save-commands.js` (note the `modules.exports =` part is important!)
```
module.exports = {
  "commands": [
    "php_tests/unit_tests/*_tests.php        : php {relFullPath}",
    "php_tests/integration_tests/*_tests.php : php {relFullPath}",
    [ "php_classes/**/*.php", function (model) {
                                // turn "php_classes/Search/Class.php" into
                                // "php_tests/unit_tests/Search_Class_tests.php"
                                let file = model.relFullPath;
                                file = file.replace( 'php_classes/', '' )
                                           .replace( model.ext, '' )
                                           .split( '/' )
                                           .join( '_' );
                                file = "php_tests/unit_tests/" + file + "_tests.php";
                                return "php " + file;
                              } ]
  ]
}
```

### Available parameters:  
- absPath: absolute path of the saved file (without file name)  
- relPath: relative path of the saved file (without file name)  
- relFullPath: like relPath but with filename
- relPathNoRoot: relative path without top folder  
- filename: file name and extension  
- name: file name without extension  
- ext: file extension  
- sep: os specific path separator

## Related packages

### [Make coffee](https://github.com/JsonHunt/make-coffee)

Great tool when you are migrating a project from JavaScript to CoffeeScript. Adds an option 'Make me a coffee' to .js files in tree-view.
