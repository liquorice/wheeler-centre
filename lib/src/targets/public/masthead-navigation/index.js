var addClass = require("../utilities/add-class");
var removeClass = require("../utilities/remove-class");

function MastheadNavigation(el, props) {
  this.active = false;
  this.toggleEl = el.querySelector(props.toggleSelector);
  this.targetEl = el.querySelector(props.targetSelector);
  this.activeClass = props.targetActiveClassName;

  this.toggleEl.addEventListener("click", this.toggle.bind(this));
}

MastheadNavigation.prototype.toggle = function(e) {
  addClass(this.targetEl, this.activeClass);
  if (this.active === true) {
    removeClass(this.targetEl, this.activeClass);
    this.active = false;
  } else {
    // Here its _inactive_, so we want to make it active
    addClass(this.targetEl, this.activeClass);
    this.active = true;
  }
}

// return the viewloader function as the export
module.exports = MastheadNavigation;
