// Filter people using a select box
function PeopleSelectBox(el, props) {
  this.selectSelector = el.querySelector(props.selectSelector);
  this.peoplePath = props.peoplePath;
  this.peopleOrderBy = props.peopleOrderBy;
  this.selectSelector.addEventListener("change", this.change.bind(this));
}

PeopleSelectBox.prototype.change = function(e) {
  window.location.href = this.peoplePath + '?letter=' + this.selectSelector.value + '&order_by=' + this.peopleOrderBy;
};

module.exports = PeopleSelectBox;
