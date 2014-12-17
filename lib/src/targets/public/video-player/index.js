// playerjs is available as a global variable `playerjs`
require("../vendor/playerjs");
var reactive = require("component/reactive");
var hms = require("yields/hms");
var TouchPreview = require("../touch-preview");

function VideoPlayer(el, props) {
  this.el = el;
  this.model = {
    duration: [],
    loaded: false,
    playing: false
  };

  this.view = reactive(el, this.model, {
    // Delegate the reactive event handlers to this instance
    // see `on-click="onCoverClick" for example
    delegate: this,
    bindings: {
      "format-duration": this.formatDuration
    }
  });

  // Set up the player
  this.player = new playerjs.Player(this.el.querySelector("iframe"));

  // Bind player events
  this.player.on("ready", this.onPlayerReady.bind(this));
  this.player.getDuration(this.onPlayerGetDuration.bind(this));

  // Manually bind the touch-preview because Reactive doesn't like
  // JSON in the data-attrs
  var teaserClassName = "video-player__teaser";
  var touchPreview = new TouchPreview(this.el.querySelector("."+teaserClassName), teaserClassName+"--preview");
}


VideoPlayer.prototype.onPlayerGetDuration = function(seconds) {
  this.view.set("duration", seconds * 1000);
};

VideoPlayer.prototype.onPlayerReady = function() {
  this.view.set("loaded", true);
};

VideoPlayer.prototype.onTeaserClick = function(e) {
  e.preventDefault();
  this.view.set("playing", true);
  this.player.play();
};

// Watch the `property` and change the `el`
VideoPlayer.prototype.formatDuration = function(el, property) {
  var binding = this;
  binding.change(function() {
    var duration = hms(binding.value(property));
    el.innerText = duration.map(function(n) { return 10 > n ? '0' + n : n; }).join(':');
  });
};

// Export the creation function
module.exports = VideoPlayer;


// The video player just plays videos in place. We’re going to use MediaElement
// to give things a custom skin so that it all looks nice.
// 1. Should warn user when leaving a page that is playing a video
// 2. Should support YouTube and handle other embeds
// 3. The markup for the player originates in _Rails_, we’re augmenting it not
//    creating it.

// The audio player is more complicated. We want it to be able to play _across_
