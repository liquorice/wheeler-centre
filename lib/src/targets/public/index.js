// Require the base CSS, basically our entry point for CSS
require("./index.css");
// Require the base JS, basically our entry point for JS
require("./base/index.js");
// Require all images and CSS by default
// This will inspect all subdirectories from the context (first param) and
// require files matching the regex. CSS is required here to get the dev
// server to watch _everything_
require.context("..", true, /^\.\/.*\.(jpe?g|png|gif|svg)$/);
