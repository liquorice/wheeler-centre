// Set a unique ID on the various inputs for the simple subscribe form
// so that we get nice label-integration
function SubscribeForm(el, props) {
  var label = el.querySelector(".simple-subscribe__label");
  var input = el.querySelector(".simple-subscribe__input");
  var id = "email-" + Math.random().toString(36).substring(7);
  label.setAttribute("for", id);
  input.setAttribute("id", id);
}

module.exports = SubscribeForm;
