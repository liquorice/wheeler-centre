function SubscribeForm(el, props) {
  var label = el.querySelector(".simple-subscribe__label");
  var input = el.querySelector(".simple-subscribe__input");
  var id = "email-" + Math.random().toString(36).substring(7);
  label.setAttribute("for", id);
  input.setAttribute("id", id);
}

module.exports = SubscribeForm;
