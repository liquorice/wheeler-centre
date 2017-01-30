var Clipboard = require("clipboard");
var addClass = require("../utilities/add-class");
var removeClass = require("../utilities/remove-class");

/**
 * Copy the contents of an element to the clipboard
 * @param  {Node}   el    The parent element
 * @param  {Object} props Various options:
 *                        - {String} triggerEl
 *                        - {String} targetEl
                          - {String} tooltipEl
 * @return {Void}
 */
function copyToClipboard(el, props) {
  var triggerEl = el.querySelector(props.triggerElement);
  var targetEl = el.querySelector(props.targetElement);
  var tooltipEl = el.querySelector(props.tooltipElement);
  var clipboard = new Clipboard(triggerEl, {
    target: function() {
      return targetEl;
    }
  });
  clipboard.on("success", function(e) {
    e.clearSelection();
    // Should we show a confirmation tooltip?
    if (tooltipEl) {
       toggleTooltip(tooltipEl);
    }
  });
}

/**
 * Toogle the tooltip element
 * @param  {Node} el The tooltip element
 * @return {Void}
 */
function toggleTooltip(el) {
  var activeClass = "copy-tooltip--active";
  var hiddenClass = "copy-tooltip--hidden";
  removeClass(el, hiddenClass);
  addClass(el, activeClass);
  setTimeout(function(){
    addClass(el, hiddenClass);
    removeClass(el, activeClass);
  },400);
}

module.exports = copyToClipboard;
