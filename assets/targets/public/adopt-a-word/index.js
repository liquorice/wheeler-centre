var addClass = require("../utilities/add-class");
var removeClass = require("../utilities/remove-class");
var Emitter = require("component-emitter");

var bus = new Emitter();

function AdoptAWordToggle(el, props) {
  this.active = false;
  this.toggleEls = el.querySelectorAll(props.toggleSelector);
  this.targetEls = el.querySelectorAll(props.targetSelector);

  for (var i = 0; i < this.toggleEls.length; i++) {
    var toggle = this.toggleEls[i];
    toggle.addEventListener("click", this.onButtonClick.bind(this));
  }

  bus.on("activate adoptaword", this.onActivateTargets.bind(this));
}

AdoptAWordToggle.prototype.onButtonClick = function(e) {
  e.preventDefault();
  if (this.active === false) {
    bus.emit("activate adoptaword", this.el);
    this.activateTargets();
  } else {
    this.deactivateTargets();
  }
};

AdoptAWordToggle.prototype.activateTargets = function(el) {
  for (var i = 0; i < this.targetEls.length; i++) {
    target = this.targetEls[i];
    addClass(target, "adopt-a-word__definition-wrapper--active");
  }
  this.active = true;
};

AdoptAWordToggle.prototype.deactivateTargets = function(el) {
  for (var i = 0; i < this.targetEls.length; i++) {
    target = this.targetEls[i];
    removeClass(target, "adopt-a-word__definition-wrapper--active");
  }
  this.active = false;
};

AdoptAWordToggle.prototype.onActivateTargets = function(el) {
  if (this.el === el && this.active) {
    this.deactivateTargets();
  }
};

module.exports = AdoptAWordToggle;
