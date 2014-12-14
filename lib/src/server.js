var http = require('http');
var url = require('url');
var path = require('path');
var fs = require('fs');
var httpProxy = require('http-proxy');

var proxy = httpProxy.createProxyServer();
var proxyTarget = 'http://localhost:5000';
var mimeTypes = {
  "html": "text/html",
  "jpeg": "image/jpeg",
  "jpg":  "image/jpeg",
  "png":  "image/png",
  "js":   "text/javascript",
  "css":  "text/css"
};

var server = http.createServer(function(req, res) {
  var uri = url.parse(req.url).pathname.replace(/^assets\//, '');
  var filename = path.join(process.cwd(), 'tmp', unescape(uri));
  var stats;

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
    var mimeType = mimeTypes[path.extname(filename).split(".").reverse()[0]];
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
