var viewloader = require("viewloader-icelab");

// App specific components
var views = require("./views");

// Kick things off
domready(viewloader.execute.bind(this, views));
