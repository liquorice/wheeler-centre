var addClass = require("../utilities/add-class.js");
var removeElement = require("../utilities/remove-element.js");

// Takes the `selector`-based children of an element and groups them into inGroup
// this is based on metaQuery breakpoints, so there should be a matching options
// hash with inGroup defined for each breakpoint in metaquery. If there’s no
// matching breakpoint the `inGroup.default` value will be used in instead:
//
//    {
//      elementsSelector: ".child",
//      fillGroups: false,
//      perGroup: {
//        default: 2
//        phone: 1,
//        tablet: 2,
//        desktop: 3
//      }
//    }

function Grouper(el, props) {
  this.el = el;
  this.props = props;
  var defaults = {
    elementsSelector: "> *",
    groupClassPrefix: "grouper",
    itemClassPrefix:  "grouper-item",
    fillGroups:       false,
    perGroup: {
      default: 2
    }
  };
  this.options = {
    elementsSelector: props.elementsSelector || defaults.elementsSelector,
    groupClassPrefix: props.groupClassPrefix || defaults.groupClassPrefix,
    itemClassPrefix:  props.itemClassPrefix || defaults.itemClassPrefix,
    fillGroups:       props.fillGroups || defaults.fillGroups,
    defaultPerGroup:  props.perGroup.default || defaults.perGroup
  };
  this.groupElements = [];
  this.elements = el.querySelectorAll(this.options.elementsSelector);
  if (this.elements.length > 0) {
    // Remove all the nodes from the DOM
    [].forEach.call(this.elements, function(element) {
      addClass(element, this.options.itemClassPrefix);
      removeElement(element);
    }.bind(this));
    metaQuery.onBreakpointChange(this.onBreakpointChange.bind(this));
  }
}

Grouper.prototype.onBreakpointChange = function(activeBreakpoints) {
  var activeBreakpoint = activeBreakpoints[0];
  var perGroup = this.props.perGroup[activeBreakpoint];
  if (!perGroup) {
    perGroup = this.options.defaultPerGroup;
  }
  this.setGroups(perGroup);
};

Grouper.prototype.setGroups = function(perGroup) {
  if (perGroup === this.currentPerGroup) return;
  // Remove all the old groups
  this.groupElements.forEach(removeElement);
  this.groupElements = [];
  var groups = this.elementsInGroups(perGroup);
  // Check the last one has enough, if not `pop` if off
  if (this.options.fillGroups === true && groups[groups.length - 1].length < perGroup) {
    groups.pop();
  }

  groups.forEach(function(group) {
    var groupElementClasses = [
      this.options.groupClassPrefix,
      this.options.groupClassPrefix + "--total-groups-" + groups.length,
      this.options.groupClassPrefix + "--total-items-" + group.length,
      this.options.groupClassPrefix + "--" + perGroup
    ];
    var groupElement = document.createElement("div");
    addClass(groupElement, groupElementClasses);
    group.forEach(function(element) {
      groupElement.appendChild(element);
    });
    this.groupElements.push(groupElement);
    this.el.appendChild(groupElement);
  }.bind(this));
  this.currentPerGroup = perGroup;
};

Grouper.prototype.elementsInGroups = function(perGroup) {
  var groups = [];
  var counter = 0;
  var lastGroupIndex = perGroup - 1;
  [].forEach.call(this.elements, function(element, index) {
    if (index % perGroup === 0) {
      groups[counter] = [];
    }
    groups[counter].push(element);
    if (index % perGroup === lastGroupIndex) {
      counter = counter + 1;
    }
  });
  return groups;
};

module.exports = Grouper;
