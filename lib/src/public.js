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
  gulp.src(tmpOut+'/**/*')
    .pipe(gulpRevAll())
    .pipe(gulp.dest(destOut))
    .pipe(gulpManifest())
    .pipe(gulp.dest(destOut));

  var finalManifest;
  gulp.src(destOut+'/manifest*')
    .pipe(gulpJsoncombine('manifest.json', function(data) {
      // Merge the various manifest.json properties together
      // jsoncombine gives us an object with the filenames as
      // the top-level keys
      var merged = {
        files: {}
      };
      for(var manifest in data) {
        for(var file in data[manifest].files) {
          merged.files[file] = data[manifest].files[file];
        }
      }
      return new Buffer(JSON.stringify(merged));
    }))
    .pipe(gulpMd5())
    .pipe(gulpTap(function(file, t) {
      var splitPath = file.path.split("/");
      finalManifest = splitPath[splitPath - 1];
    }))
    .pipe(gulp.dest(destOut));

  // Delete the original manifest files
  // del([
  //   destOut+'/manifest.json',
  //   destOut+'/manifest*.*',
  //   '!'+finalManifest
  //   ], {force: true});
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
