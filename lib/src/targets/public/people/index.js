var clamp = require("../vendor/clamp.js");

function PeopleIndexBio(el, props) {
  var eventEls = el.querySelectorAll(props.eventSelector);
  [].forEach.call(eventEls, function(eventEl) {
    $clamp(eventEl, {clamp: 3});
  });
}

module.exports = PeopleIndexBio;
