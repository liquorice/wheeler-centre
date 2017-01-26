var Clipboard = require("clipboard");

function CopyToClipboard(el, props) {
  var triggerEl = el.querySelector(props.triggerElement);
  var targetEl = el.querySelector(props.targetElement);
  var clipboard = new Clipboard(triggerEl, {
    target: function() {
      return targetEl;
    }
  });
  clipboard.on('success', function(e) {
    console.info('Action:', e.action);
  });
}

module.exports = CopyToClipboard;
