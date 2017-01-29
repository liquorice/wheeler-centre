var Clipboard = require("clipboard");

/**
 * Copy the contents of an element to the clipboard
 * @param  {Node}   el    The parent element
 * @param  {Object} props Various options:
 *                        - {String} triggerEl
 *                        - {String} targetEl
                          - {Bool}   showTooltip
 * @return {Void}
 */
function copyToClipboard(el, props) {
  var triggerEl = el.querySelector(props.triggerElement);
  var targetEl = el.querySelector(props.targetElement);
  var showTooltip = props.showTooltip;
  var clipboard = new Clipboard(triggerEl, {
    target: function() {
      return targetEl;
    }
  });
  clipboard.on("success", function(e) {
    e.clearSelection();
    // Should we show a confirmation tooltip?
    if (showTooltip) {
      createTooltip(triggerEl, "Copied");
    }
  });
}

/**
 * Create a tooltip
 * @param  {Node}   targetEl The element to append the tooltip
 * @param  {String} text     Contents of the tooltip
 * @return {Void}
 */
function createTooltip(targetEl, text) {
  var tooltipEl = document.createElement("span");
  tooltipEl.className = "copy-tooltip";
  tooltipEl.innerHTML = text;
  targetEl.appendChild(tooltipEl);
  setTimeout(function(){
    targetEl.removeChild(tooltipEl);
  },600);
}

module.exports = copyToClipboard;
