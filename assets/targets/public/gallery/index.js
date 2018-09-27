var modalGallery = require("../modal-gallery");

module.exports = function gallery(el, props) {
  var gal = modalGallery(props.slides);
  var buttons = Array.prototype.slice.call(el.querySelectorAll("a, button"));
  buttons.forEach(function(button, i) {
    button.addEventListener("click", function(e) {
      e.preventDefault();
      gal.open(i, true);
    });
  });
};
