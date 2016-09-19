
save_commands = require "../lib/atom-save-commands"
util = require 'util'

describe "when we look for a file", ->
	it "finds a matching command", ->
		save_commands.config = { commands: [ { glob: "*", command: "a_command" } ] }
		expect( save_commands.getCommandsFor("anything") ).toEqual( ["a_command"] )

describe "when we load the config file", ->
	it "can load a JSON file", ->
		save_commands.loadConfig "./spec", "save-commands.json", ()=>
			# console.log util.inspect save_commands.config
			expect( save_commands.config.commands[0].glob.substring( 0, 15 ) ).toEqual( "lib/**/*.coffee" )
	it "can load a JS file", ->
		save_commands.loadConfig "./spec", "save-commands-sample.js", ()=>
			# console.log util.inspect save_commands.config
			expect( save_commands.config.commands[0].glob ).toEqual( "lib/**/*.coffee" )
			expect( save_commands.config.commands[1].glob ).toEqual( "*glob" )


describe "when we try to use splitOnce", ->
	it "works for a simple string", ->
		expect( save_commands.splitOnce( "" ) ).toEqual( [ '', '' ]  )
		expect( save_commands.splitOnce( "blah:blee", ":") ).toEqual( [ 'blah', 'blee' ] )


describe "when we try to use splitConfigCommand", ->
	it "works for a string", ->
		expect( save_commands.splitConfigCommand( "blah : blee" ) ).toEqual( { glob: 'blah', command: 'blee' } )
	it "works for an array", ->
		expect( save_commands.splitConfigCommand( [ "blah", "blee" ] ) ).toEqual( { glob: 'blah', command: 'blee' } )


# TEST: given a "command" config hash, we can lookup commands for a file

describe "when we try to convert a command", ->
	it "at least executes without error", ->
		expect( save_commands.convertCommand( "./spec", "a_command" ) ).toEqual( "a_command" )
	it "will do some basic replacement", ->
		expect( save_commands.convertCommand( "./spec", "{filename}" ) ).toEqual( "spec" )
	it "will work with a callback", ->
		expect( save_commands.convertCommand( "./spec", ()=>"done" ) ).toEqual( "done" )
		expect( save_commands.convertCommand( "./spec", (model)=>"done"+model.filename ) ).toEqual( "donespec" )
#
describe "when we load a JS config file", ->
	it "will properly execute a defined callback", ->
		save_commands.loadConfig "./spec", "save-commands-sample.js", ()=>
			expect( save_commands.getCommandsFor("anything") ).toEqual( ["c_cmd","d_cmd.anything" ] )
