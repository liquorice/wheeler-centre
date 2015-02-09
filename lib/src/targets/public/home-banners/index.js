var addClass = require("../utilities/add-class.js");
var removeElement = require("../utilities/remove-element.js");

// We're basically reimplementing flexbox
// 2 = large, 1 = small
var layouts = [
  [
    [1]
  ],
  [
    [1], [1]
  ],
  [
    [2], [1, 1]
  ],
  [
    [2], [1, 1], [2]
  ],
  [
    [1, 1], [2], [1, 1]
  ],
  [
    [2,1,1], [1,1,2]
  ],
  [
    [1, 1, 1, 1], [1, 1, 1]
  ],
  [
    [2,1,1], [1,1,2], [1,1]
  ],
  [
    [2,1,1], [1,1,2], [2,1,1]
  ]
];

function widthClass(width) {
  return (width === 1) ? "one" : "two";
}

function maxValue(previous, current) {
  return previous > current ? previous : current;
}

function HomeBanners(el, props) {
  this.el = el;
  this.bannerElements =  Array.prototype.slice.call(el.querySelectorAll(props.bannerSelector));
  this.totalBanners = this.bannerElements.length;
  if (this.totalBanners > 0) {
    // Remove all the nodes from the DOM
    this.bannerElements.forEach(function(element) {
      removeElement(element);
    });
    // Set a layout based on the length of the banners
    this.setLayout(layouts[this.totalBanners - 1]);
  }
}

HomeBanners.prototype.setLayout = function(layout) {
  addClass(this.el, ["home-banners--total-" + this.totalBanners]);
  // Iterate over each group in the chosen layout
  layout.forEach(function(group) {
    var groupMaxWidth = group.reduce(maxValue);
    var groupClassNames = [
      "home-banner__group",
      "home-banner__group--layout-" + this.totalBanners,
      "home-banner__group--max-width-" + widthClass(groupMaxWidth)
    ];
    var groupElement = document.createElement("div");
    addClass(groupElement, groupClassNames);
    // Then each block in the group
    group.forEach(function(width) {
      var bannerElement = this.bannerElements.shift();
      var bannerClassNames = [
        "home-banner--width-" + widthClass(width)
      ];
      addClass(bannerElement, bannerClassNames);
      // Append the banner
      groupElement.appendChild(bannerElement);
    }.bind(this));
    // Append the group element
    this.el.appendChild(groupElement);
  }.bind(this));
};

module.exports = HomeBanners;
