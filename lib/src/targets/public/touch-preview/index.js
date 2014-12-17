function addClass(el, className) {
  if (el.classList) {
    el.classList.add(className);
  } else {
    el.className += ' ' + className;
  }
}

function removeClass(el, className) {
  if (el.classList) {
    el.classList.remove(className);
  } else {
    el.className = el.className.replace(new RegExp('(^|\\b)' + className.split(' ').join('|') + '(\\b|$)', 'gi'), ' ');
  }
}

function TouchPreview(el, previewClassName) {
  this.el = el;
  this.previewClassName = previewClassName;
  // Bind listeners
  this.el.addEventListener("touchstart", this.startPreview.bind(this));
  this.el.addEventListener("mouseover", this.startPreview.bind(this));
  this.el.addEventListener("touchend", this.endPreview.bind(this));
  this.el.addEventListener("touchmove", this.endPreview.bind(this));
  this.el.addEventListener("mouseout", this.endPreview.bind(this));
}

TouchPreview.prototype.startPreview = function(e) {
  addClass(this.el, this.previewClassName);
};

TouchPreview.prototype.endPreview = function(e) {
  removeClass(this.el, this.previewClassName);
};

module.exports = TouchPreview;
