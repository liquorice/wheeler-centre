/**
 * Module dependencies
 */

var Duo = require('duo');
var fs = require('fs');
var path = require('path')
var write = require('fs').writeFileSync;

var Batch = require('batch');
var CleanCSS = require('clean-css');
var del = require('del');
var jsx = require('duo-jsx');
var myth = require('myth');
var uglify = require('uglify-js');

// Gulp dependencies
var gulp = require('gulp');
var gulpJsoncombine = require('gulp-jsoncombine');
var gulpMd5 = require('gulp-md5');
var gulpManifest = require('gulp-rev-rails-manifest');
var gulpRevAll = require('gulp-rev-all');
var runSequence = require('run-sequence');
var gulpTap = require('gulp-tap');

var cleanCSS = new CleanCSS();

/**
 * Settings
 */

var dev = process.env.NODE_ENV === 'development';
// Set the root to our main directory
var root = __dirname;
// Everything else is _relative_ to the `root`
var tmp = 'tmp/'
var dest = '../../public/assets/';
var targetsPath = 'targets/';
var tmpRelativeToTargets = '../../'+tmp;
var tmpOut = path.join(root, tmp);
var destOut = path.join(root, dest);

function buildJSTarget(name) {
  var target = {
    name: name,
    type: 'js',
    duo: Duo(path.join(root, targetsPath, name))
      .entry('./index.js')
      .use(jsx())
  };
  return target;
};

function buildCSSTarget(name) {
  var target = {
    name: name,
    type: 'css',
    duo: Duo(path.join(root, targetsPath, name))
      .entry('./index.css')
      .buildTo(tmpRelativeToTargets)
      .copy(true)
  };
  return target;
};

// Pull the targets out of the arguments passed by Make
var targetPaths = process.argv[2].split(" ");
// Split into JS/CSS targets
var targets = [];
for (var i = 0; i < targetPaths.length; i++) {
  var target = targetPaths[i];
  var folder = path.dirname(target).split('/');
  folder = folder[folder.length - 1];
  if (/.js$/.test(target)) {
    targets.push(
      buildJSTarget(folder)
    );
  } else if (/.css$/.test(target)) {
    targets.push(
      buildCSSTarget(folder)
    );
  }
};


/**
 * Generate a Rails-compatible manifest
 */

function generateManifest() {
  // Delete everything from the destination
  // del(destOut+'/*', {force: true});
  gulp.task('manifest:duo', function(cb) {
    console.log('Starting manifest:duo task');
    var stream = gulp.src(tmpOut+'/**/*')
      .pipe(gulpRevAll({
        transformFilename: function (file, hash) {
          var ext = path.extname(file.path);
          return path.basename(file.path, ext) + '-' + hash + ext;
        }
      }))
      .pipe(gulp.dest(destOut))
      .pipe(gulpManifest())
      .pipe(gulp.dest(destOut));
    stream.on("end", function() {
      console.log('Completed manifest:duo task');
      cb();
    });
  });

  var finalManifest;
  gulp.task('manifest:combine', ['manifest:duo'], function(cb) {
    console.log('Started manifest:combine task');
    var stream = gulp.src(destOut+'/manifest*')
      .pipe(gulpJsoncombine('manifest.json', function(data) {
        // Merge the various manifest.json properties together
        // jsoncombine gives us an object with the filenames as
        // the top-level keys
        var merged = {
          files: {},
          assets: {}
        };
        for(var manifest in data) {
          for(var file in data[manifest].files) {
            merged.files[file] = data[manifest].files[file];
          }
          for(var asset in data[manifest].assets) {
            merged.assets[asset] = data[manifest].assets[asset];
          }
        }
        return new Buffer(JSON.stringify(merged));
      }))
      .pipe(gulpMd5())
      .pipe(gulpTap(function(file, t) {
        // Get the generated filename
        var splitPath = file.path.split("/");
        finalManifest = splitPath[splitPath.length - 1];
      }))
      .pipe(gulp.dest(destOut));
    stream.on("end", function() {
      console.log('Completed manifest:combine task');
      cb();
    });
  });

  // Delete the original manifest files
  gulp.task('manifest:clean', ['manifest:combine', 'manifest:duo'], function(cb) {
    console.log('Started manifest:clean');
    del([
      destOut+'manifest*',
      '!'+destOut+finalManifest
      ], {force: true}, cb);
  });
  runSequence([
    'manifest:duo',
    'manifest:combine',
    'manifest:clean'
  ]);
};

/**
 * Run JS/CSS together
 */

var batch = new Batch();
for (var i = 0; i < targets.length; i++) {
  var target = targets[i];
  batch.push(target.duo.run.bind(target.duo));
};

batch.end(function(err, res) {
  if (err) throw err;

  for (var i = 0; i < targets.length; i++) {
    var output;
    var target = targets[i];
    var build = res[i];
    if (target.type === 'js') {
      output = (dev) ? build : uglify.minify(build, { fromString: true}).code;
    } else if (target.type === 'css') {
      output = cleanCSS.minify(myth(build));
    }
    write(path.join(tmpOut, target.name + '.' + target.type), output);
  }

  if (!dev) {
    generateManifest();
  }
});
