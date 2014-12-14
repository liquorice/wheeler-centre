/**
 * Module dependencies
 */

var Duo = require('duo');
var fs = require('fs');
var join = require('path').join;
var write = require('fs').writeFileSync;

var Batch = require('batch');
var CleanCSS = require('clean-css');
var del = require('del');
var jsx = require('duo-jsx');
var myth = require('myth');
var serve = require('duo-serve');
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
var root = join(__dirname, './public');
// Everything else is _relative_ to the `root`
var tmp = '../tmp/'
var dest = '../../../public/assets/';
var tmpOut = join(root, tmp);
var destOut = join(root, dest);

/**
 * JS.
 */

var js = Duo(root)
  .entry('./index.js')
  .use(jsx());

/**
 * CSS.
 */

var css = Duo(root)
  .entry('./index.css')
  .buildTo(tmp)
  .copy(true);

/**
 * Generate a Rails-compatible manifest
 */

function generateManifest() {
  // Delete everything from the destination
  // del(destOut+'/*', {force: true});
  gulp.task('manifest:duo', function(cb) {
    console.log('manifest:duo');
    var stream = gulp.src(tmpOut+'/**/*')
      .pipe(gulpRevAll())
      .pipe(gulp.dest(destOut))
      .pipe(gulpManifest())
      .pipe(gulp.dest(destOut));
    stream.on("end", function() {
      console.log('manifest:duo - complete');
      cb();
    });
  });

  var finalManifest;
  gulp.task('manifest:combine', ['manifest:duo'], function(cb) {
    console.log('manifest:combine');
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
        console.log(file.path);
        var splitPath = file.path.split("/");
        finalManifest = splitPath[splitPath.length - 1];
      }))
      .pipe(gulp.dest(destOut));
    stream.on("end", function() {
      console.log('manifest:combine - complete');
      cb();
    });
  });

  // Delete the original manifest files
  gulp.task('manifest:clean', ['manifest:combine', 'manifest:duo'], function(cb) {
    console.log('manifest:clean');
    console.log('!'+destOut+finalManifest);
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

batch.push(js.run.bind(js));
batch.push(css.run.bind(css));

batch.end(function(err, res) {
  if (err) throw err;

  var js = (dev) ? res.shift() : uglify.minify(res.shift(), { fromString: true}).code;
  write(join(tmpOut, 'public.js'), js);

  var css = cleanCSS.minify(myth(res.shift()));
  write(join(tmpOut, 'public.css'), css);

  if (!dev) {
    generateManifest();
  }
});
