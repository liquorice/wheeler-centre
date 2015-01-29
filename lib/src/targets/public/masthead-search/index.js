var addClass = require("../utilities/add-class");
var removeClass = require("../utilities/remove-class");

function MastheadSearch(el, props) {
  this.toggleEl = el.querySelector(props.toggleSelector);
  this.targetEl = el.querySelector(props.targetSelector);
  this.closeEl = el.querySelector(props.closeSelector);
  this.activeClass = props.targetActiveClassName;

  this.toggleEl.addEventListener("click", this.open.bind(this));
  this.closeEl.addEventListener("click", this.close.bind(this));
}

MastheadSearch.prototype.open = function(e) {
  e.preventDefault();
  addClass(this.targetEl, this.activeClass);
}

MastheadSearch.prototype.close = function(e) {
  removeClass(this.targetEl, this.activeClass);
}

// return the viewloader function as the export
module.exports = MastheadSearch;
