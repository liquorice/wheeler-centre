var http = require('http');
var url = require('url');
var path = require('path');
var fs = require('fs');
var httpProxy = require('http-proxy');
var mime = require('mime');

var proxy = httpProxy.createProxyServer();
var proxyTarget = 'http://localhost:5000';

var server = http.createServer(function(req, res) {
  // Remap requests for /assets to /
  var uri = url.parse(req.url).pathname;
  var filename = path.join(__dirname, 'tmp', unescape(uri.replace(/^\/assets\//, '/')));
  var stats;

  // Don't cache responses
  res.setHeader('Cache-Control', 'private, no-cache, no-store, must-revalidate');
  res.setHeader('Expires', '-1');
  res.setHeader('Pragma', 'no-cache');
  // Set CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Request-Method', '*');
  res.setHeader('Access-Control-Allow-Methods', 'OPTIONS, GET');
  res.setHeader('Access-Control-Allow-Headers', '*');

  try {
    // Throws if path doesn't exist
    stats = fs.lstatSync(filename);
  } catch (e) {
    console.log("Proxying to "+proxyTarget+uri);
    // Proxy through to Rails if doesn't exist
    proxy.web(req, res, {
      target: proxyTarget
    });
    return;
  }

  if (stats.isFile()) {
    console.log("Serving "+uri);
    // Path exists and is a file
    var mimeType = mime.lookup(filename);
    res.writeHead(200, {'Content-Type': mimeType} );
    var fileStream = fs.createReadStream(filename);
    fileStream.pipe(res);
  } else if (stats.isDirectory()) {
    // Path exists and is a directory
    res.writeHead(200, {'Content-Type': 'text/plain'});
    res.write('Index of '+uri+'\n');
    res.end();
  } else {
    // Path is something else
    res.writeHead(500, {'Content-Type': 'text/plain'});
    res.write('500 Internal server error\n');
    res.end();
  }
});

// Listen
server.listen(1234);
