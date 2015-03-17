var http = require("http");
var path = require('path');
var express = require("express");
var httpProxy = require('http-proxy');
var webpack = require("webpack");
var webpackDevMiddleware = require("webpack-dev-middleware");
var WebpackDevServer = require("webpack-dev-server");
var webpackConfig = require("./webpack.config.js");

// Configuration
var BUILD   = path.join(__dirname, "build");
// TODO move to ENVs
var DEVELOPMENT_PORT = "1234";
var WEBPACK_PORT     = "8080";
var PROXY_URL = "http://localhost:5000";

// Webpack middleware
var webpackMiddleware = webpackDevMiddleware(webpack(webpackConfig), {
  noInfo: true,
  publicPath: "/assets/"
});

// Rails proxy
var proxy = httpProxy.createProxyServer();
var proxyTarget = PROXY_URL;

// Express app
var app = express();

// Tell Express to use the webpackMiddleware
app.use(webpackMiddleware);

// Check each request and proxies misses through to Rails
app.get("*", function(req, res, next) {
  // Check if a file exists in the webpack bundle
  try {
    // Throws if path doesn't exist
    webpackMiddleware.fileSystem.readFileSync(__dirname + '/build'+req.url)
  } catch (e) {
    console.log("Proxying to "+proxyTarget+req.url);
    // Proxy through to Rails if doesn't exist
    proxy.web(req, res, {
      target: proxyTarget
    });
    return;
  }
});

// Boot the server
var port = DEVELOPMENT_PORT;
var server = http.Server(app);
server.listen(port, function() {
  console.log("Listening at http://localhost:" + DEVELOPMENT_PORT + "/");
});

// User the webpack-dev-server specifically for hot-loading
var devServer = new WebpackDevServer(webpack(webpackConfig), {
  contentBase: BUILD,
  hot: true,
  quiet: false,
  noInfo: false,
  publicPath: "/assets/",
  stats: { colors: true }
});

// Needs to be on 8080 as the websocket expects that
devServer.listen(WEBPACK_PORT, "localhost", function() {});
