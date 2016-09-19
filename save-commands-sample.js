module.exports = {
	"timeout": 2000,
	"commands": [
		"lib/**/*.coffee : echo coffee -n {relFullPath}",
		[ "*glob", "echo command" ],
		[ "*", function () { return "c_cmd" } ],
		[ "*", function (model) { return "d_cmd." + model.filename } ]
	]
}
