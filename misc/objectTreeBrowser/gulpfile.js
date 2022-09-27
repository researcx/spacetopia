var gulp = require('gulp'),
    exec = require('child_process').exec,
    fs  = require("fs"),
	lbl = require("line-by-line"),
	_ = require('lodash');


gulp.task('default', ['build', 'reparse', 'generate', 'tojson']);

gulp.task('build', function(cb) {
	cb();return;
    return exec('dm -o ..\\goonstation\\goonstation.dme > objectTree.txt', function(err, stdout, stderr) {
		console.log(stdout);
		console.log(stderr);
		cb(err);
	});
});


gulp.task('reparse', ['build'], function(cb) {
	cb();return;
	// Why do i use php? Because I'm lazy as fuck. sue me.
	return exec('php reparseObjectTree.php objectTree.txt objectTree.xml', function(err, stdout, stderr){
		console.log(stdout);
		console.log(stderr);
		cb(err);
	});
});

function rebuildObject(obj, path, parentType) {
	if (obj instanceof Array) {
		return obj.map(function(o){return rebuildObject(o, path, parentType)});
	}
	var curPath = path,
		pathSeg;
		
	var ret = _.pairs(obj).map(function(p){
		if (p[0] == 'val')
			return null;
		if (p[0] == '_') {
			p[0] = 'name';
			p[1] = p[1].replace(/['"\\]/, '').trim();
			pathSeg = (typeof parentType === 'undefined' || parentType.match(/(turf|mob|area|object|obj)/)) ? '' : '/' + parentType;
			curPath = path + pathSeg + '/' + p[1].toString();
		} else if (p[0] == '$') {
			p[0] = 'file';
			p[1] = p[1].file;
		} else {
			p[1] = rebuildObject(p[1], curPath, p[0]);
		}
		return p;
		
	});
	ret = _.zipObject(_.filter(ret));
	
	if (typeof ret.file === 'string') {
		ret.line = ret.file.split(':')[1];
		ret.file = ret.file.split(':')[0];
	} else {
		ret.line = ret.file = null;
	}
	ret.path = curPath;
	return ret;
}

gulp.task('tojson', ['build', 'reparse'], function(cb) {
	var xml2js = require('xml2js'),
		parser = new xml2js.Parser();
	fs.readFile('objectTree.xml', function(err, data) {
		parser.parseString(data, function(err, result) {
			var tree = result.tree;
			tree = rebuildObject(tree, '');
			//fs.writeFileSync('objectTreeResult.json', JSON.stringify(result, null, '\t'));
			fs.writeFile('objectTree.json', JSON.stringify({'root':tree}, null, '\t'), cb);
		});
	});
});
gulp.task('generate', ['tojson'], function() {});

