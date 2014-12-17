// Picturefill is vendored at pre-2.4.0 release for commonjs compat
var picturefill = require("./vendor/picturefill");
var viewloader = require("./viewloader");

// App specific components
var views = require("./views");

// Kick things off
domready(viewloader.execute.bind(this, views));
