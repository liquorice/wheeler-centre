require("es5-shim");
var viewloader = require("viewloader");

var views = {};

// Kick things off
domready(viewloader.execute.bind(this, views));
