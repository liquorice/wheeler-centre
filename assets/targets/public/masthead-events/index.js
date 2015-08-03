var clamp = require("../vendor/clamp.js");

function MastheadEvents(el, props) {
  var eventEls = el.querySelectorAll(props.eventSelector);
  [].forEach.call(eventEls, function(eventEl) {
    $clamp(eventEl, {clamp: 2});
  });
}

module.exports = MastheadEvents;
