// playerjs is available as a global variable `playerjs`
require("../vendor/playerjs");
var reactive = require("component/reactive");
var hms = require("yields/hms");
var queryString = require("sindresorhus/query-string");
var parseTime = require("../parse-time");
var TouchPreview = require("../touch-preview");

function iOS() {
  return ( navigator.userAgent.match(/(iPad|iPhone|iPod)/g) ? true : false );
}

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

  window.addEventListener("hashchange", this.moveToTimeHash.bind(this), false);

  // Set up the player
  this.player = new playerjs.Player(this.el.querySelector("iframe"));

  // Bind player events
  this.player.on("ready", this.onPlayerReady.bind(this));
  this.player.on("ended", this.onPlayerEnded.bind(this));
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
  this.moveToTimeHash();
};

VideoPlayer.prototype.onPlayerEnded = function() {
  setTimeout(function() {
    this.view.set("playing", false);
  }.bind(this), 1000);
};

VideoPlayer.prototype.onTeaserClick = function(e) {
  e.preventDefault();
  this.view.set("playing", true);
  if (!iOS()) {
    this.player.play();
  }
};

// Watch the `property` and change the `el`
VideoPlayer.prototype.formatDuration = function(el, property) {
  var binding = this;
  binding.change(function() {
    var duration = hms(binding.value(property));
    el.innerText = duration.map(function(n) { return 10 > n ? '0' + n : n; }).join(':');
  });
};

// Transfer a location has like /video#t=1h15m10s into the video time
VideoPlayer.prototype.moveToTimeHash = function() {
  var hashParams = queryString.parse(location.hash);
  if (hashParams.t) {
    var time = parseTime(hashParams.t);
    if (time > 0 && this.model.duration <= time) {
      this.player.setCurrentTime(time);
      this.view.set("playing", true);
    }
  }
};

// Export the creation function
module.exports = VideoPlayer;
