var clamp = require("../vendor/clamp.js");

function PeopleIndexBio(el, props) {
  var peopleEls = el.querySelectorAll(props.peopleSelector);
  [].forEach.call(peopleEls, function(peopleEl) {
    $clamp(peopleEl, {clamp: 3});
  });
}

// function PeopleSelectBox(el, props) {
//   var selectEl = el.querySelector(props.selectSelector);
//   console.log("foo");
// }

module.exports = PeopleIndexBio;
// module.exports = PeopleSelectBox;
