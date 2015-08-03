function VenuePage(el, props) {
  this.swapContentElements(el.querySelector(".venue__description"), el.querySelector(".venue__meta"));
}

VenuePage.prototype.swapContentElements = function(one, two) {
  if (one && two) {
    var oneHeight = one.offsetHeight;
    var twoHeight = two.offsetHeight;
    if (oneHeight < twoHeight) {
      var parent = one.parentNode;
      parent.removeChild(one);
      parent.appendChild(one);
    }
  }
};

module.exports = VenuePage;
