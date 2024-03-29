var dotenv = require("dotenv");
var fs = require("fs");
var path = require("path");
var webpack = require("webpack");

/**
 * Custom webpack plugins
 */
var ExtractTextPlugin = require("extract-text-webpack-plugin");
var WebpackNotifierPlugin = require("webpack-notifier");

/**
 * PostCSS packages
 */

var autoprefixer = require("autoprefixer-core");
var cssimport = require("postcss-import");
var cssnext = require("cssnext");

/**
 * General configuration
 */
dotenv.load("../");
var TARGETS = path.join(__dirname, "targets");
var BUILD   = path.join(__dirname, "build");


/**
 * isDirectory
 *
 * @param  {dir} file Check if the passed path is a directory
 * @return {Boolean}
 */
function isDirectory(dir) {
  return fs.lstatSync(dir).isDirectory();
}


/**
 * isFile
 *
 * @param  {string} file Check if the passed path is a file
 * @return {Boolean}
 */
function isFile(file) {
  return fs.lstatSync(file).isFile();
}


/**
 * createEntries
 *
 * Iterate through the `TARGETS`, find any matching `target.js` files, and
 * return those as entry points for the webpack output.
 */
function createEntries(entries, dir) {
  if (isDirectory(path.join(TARGETS, dir))) {
    // Prepend the webpack hot-loading contexts for the targets
    var target = ["webpack-dev-server/client?http://localhost:8080", "webpack/hot/dev-server"];
    var file = path.join(TARGETS, dir, "target.js");
    try {
      isFile(file);
    } catch (e) {
      return;
    }
    target.push(file);
    entries[dir] = target;
  }
  return entries;
}

/**
 * Plugin setup
 */

var plugins = [
  new webpack.NoErrorsPlugin(),
  new webpack.HotModuleReplacementPlugin(),
  new webpack.DefinePlugin({
    DEVELOPMENT: true
  }),
  new ExtractTextPlugin("[name].css", {
    allChunks: true
  })
];

// Enable the webpack notifier plugin unless explicitly disabled in the
// ENV setup.
if (process.env.DISABLE_ASSETS_NOTIFIER === undefined) {
  plugins.push(
    new WebpackNotifierPlugin({title: "Webpack assets"})
  );
}

/**
 * Webpack configuration
 */
module.exports = {

  // Set proper context
  context: TARGETS,

  // Generate the `entry` points from the filesystem
  entry: fs.readdirSync(TARGETS).reduce(createEntries, {}),

  // Configure output
  output: {
    // Output into our build directory
    path: BUILD,
    // Template based on keys in entry above
    // Generate hashed names for production
    filename: "[name].js",
    // Ensure the publicPath matches the expected location in development
    publicPath: "http://localhost:"+process.env.ASSETS_DEVELOPMENT_PORT+"/assets/"
  },

  // Plugin definitions
  plugins: plugins,

  // Plugin/loader specific-configuration
  cssnext: {
    map: false,
    compress: false
  },
  jshint: {
    eqnull: true,
    failOnHint: false
  },
  postcss: function() {
    return {
      defaults: [
        cssimport({
          // Add each @import as a dependency so the bundle is rebuilt
          // when imported files change.
          onImport: function (files) {
            files.forEach(this.addDependency);
          }.bind(this)
        }),
        cssnext(),
        autoprefixer
      ],
      cleaner:  [autoprefixer({ browsers: ["last 2 versions"] })]
    };
  },

  // General configuration
  module: {
    preLoaders: [
      // Run all JavaScript through jshint before loading
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: "jshint-loader"
      }
    ],
    loaders: [
      {
        test: /\.(jpe?g|png|gif|svg|woff|ttf|otf|eot|ico)/,
        loader: "file-loader?name=[path][name].[ext]"
      },
      {
        // Shim the AMD modules in this stuff by disabling AMD
        test: /(draggabilly|get-size|unidragger|eventie|eventemitter)/,
        loader: "imports-loader?define=>false"
      },
      {
        test: /\.html$/,
        loader: "html-loader"
      },
      {
        test: /\.css$/,
        // The ExtractTextPlugin pulls all CSS out into static files
        // rather than inside the JavaScript/webpack bundle
        loader: ExtractTextPlugin.extract("style-loader", "css-loader!postcss-loader")
      }
    ]
  }

};
