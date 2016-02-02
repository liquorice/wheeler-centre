var viewloader = require("viewloader");

// App specific components
var views = require("./views");

// Kick things off
domready(viewloader.execute.bind(this, views));
