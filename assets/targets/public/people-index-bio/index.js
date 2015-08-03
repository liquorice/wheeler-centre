var clamp = require("../vendor/clamp.js");

// Truncate bios on the people index page
function PeopleIndexBio(el, props) {
  var peopleEls = el.querySelectorAll(props.peopleSelector);
  [].forEach.call(peopleEls, function(peopleEl) {
    $clamp(peopleEl, {clamp: 3});
  });
}

module.exports = PeopleIndexBio;
