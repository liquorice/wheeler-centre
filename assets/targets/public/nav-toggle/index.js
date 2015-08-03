var addClass = require("../utilities/add-class");
var removeClass = require("../utilities/remove-class");

function NavToggle(el, props) {
  this.props = props;
  this.active = false;
  this.preventLinks = false;
  if (props.preventLinks) {
    this.preventLinks = props.preventLinks.default;
  }
  this.toggleEl = el.querySelector(props.toggleSelector);
  this.targetEl = el.querySelector(props.targetSelector);
  this.activeClass = props.targetActiveClassName;

  this.toggleEl.addEventListener("click", this.toggle.bind(this));
  if (this.props.preventLinks) {
    metaQuery.onBreakpointChange(this.onBreakpointChange.bind(this));
  }
}

NavToggle.prototype.toggle = function(e) {
  if (this.preventLinks === true) {
    e.preventDefault();
  }
  addClass(this.targetEl, this.activeClass);
  if (this.active === true) {
    removeClass(this.targetEl, this.activeClass);
    this.active = false;
  } else {
    addClass(this.targetEl, this.activeClass);
    this.active = true;
  }
};

NavToggle.prototype.onBreakpointChange = function(activeBreakpoints) {
  var activeBreakpoint = activeBreakpoints[0];
  this.preventLinks = this.props.preventLinks[activeBreakpoint];
};


module.exports = NavToggle;
