var fs = require('fs');
var path = require('path');
var webpack = require('webpack');

// Webpack plugins
var ComponentPlugin = require("component-webpack-plugin");
var ExtractTextPlugin = require("extract-text-webpack-plugin");

// Configuration
var TARGETS = path.join(__dirname, "targets");
var BUILD   = path.join(__dirname, "build");

module.exports = {
  context: TARGETS,
  entry: fs.readdirSync(TARGETS).reduce(createEntries, {}),
  output: {
    path: BUILD,
    // Template based on keys in entry above
    // Generate hashed names for production
    filename: "[name].js",
    publicPath: "/assets/"
  },
  plugins: [
    new ExtractTextPlugin("[name].css", {
      allChunks: true
    }),
    new ComponentPlugin(),
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoErrorsPlugin()
  ],
  module: {
    loaders: [
      {
        // Shim the AMD modules in this stuff by disabling AMD
        test: /(draggabilly|get-size|unidragger|eventie|eventemitter)/,
        loader: "imports?define=>false"
      },
      {
        test: /\.(jpe?g|png|gif|svg|woff|ttf|otf|eot|ico)/,
        loader: "file-loader?name=[path][name].[ext]"
      },
      {
        test: /\.css$/,
        loader: ExtractTextPlugin.extract("style-loader", "css-loader!autoprefixer-loader!cssnext-loader")
      }
    ]
  }
};

function isDirectory(dir) {
  return fs.lstatSync(dir).isDirectory();
}

function isFile(file) {
  return fs.lstatSync(file).isFile();
}

function createEntries(entries, dir) {
  if (isDirectory(path.join(TARGETS, dir))) {
    var file = path.join(TARGETS, dir, "index.js");
    try {
      isFile(file);
    } catch (e) {
      return;
    }
    entries[dir] = [file];
  }
  return entries;
}
