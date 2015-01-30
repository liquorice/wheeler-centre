var reactive = require("component/reactive");
var Drag = require("mnmly/drag");
var hms = require("yields/hms");
var TouchPreview = require("../touch-preview");

function AudioPlayer(el, props) {
  this.el = el;
  this.handleEl = this.el.querySelector(".audio-player__handle");
  this.model = {
    duration: 0,
    currentTime: 0,
    loaded: false,
    playing: false,
    loadProgress: 0,
    playProgress: 0,
    trackPosition: 0,
    elementWidth: 0
  };

  this.view = reactive(el, this.model, {
    // Delegate the reactive event handlers to this instance
    // see `on-click="onCoverClick" for example
    delegate: this,
    bindings: {
      "format-duration": this.formatDuration,
      "format-track-position": this.formatTrackPosition,
      "format-handle-position": this.formatHandlePosition
    }
  });

  // Handle
  this.setupDragHandle();
  window.addEventListener("resize", this.onResize.bind(this), false);
  this.handle.on("drag", this.onHandleDrag.bind(this));
  this.handle.on("dragend", this.onHandleDragEnd.bind(this));

  // Set up the player
  this.player = el.querySelector("audio");
  this.player.addEventListener("loadedmetadata", this.onMetadataLoaded.bind(this));
  this.player.addEventListener("timeupdate", this.onTimeUpdate.bind(this));
}


AudioPlayer.prototype.onResize = function() {
  this.setupDragHandle();
};


AudioPlayer.prototype.setupDragHandle = function() {
  var handleWidth = 40;
  var handleOffset = handleWidth / 2;
  this.view.set("elementWidth", this.el.offsetWidth);
  // Reinitialise
  this.handle = new Drag(this.handleEl, {
    axis: "x",
    range: {
      x: [0 + handleOffset, this.model.elementWidth - handleOffset]
    }
  });
  // Reposition the handle inside parent if it overflows
  this.handleEl.style.left = (this.model.elementWidth * this.model.trackPosition) + "px";
};

AudioPlayer.prototype.onMetadataLoaded = function(e) {
  this.view.set("loaded", true);
  this.view.set("duration", this.player.duration);
};

// Watch the `property` and change the `el`
AudioPlayer.prototype.formatDuration = function(el, property) {
  var binding = this;
  binding.change(function() {
    var duration = hms(binding.value(property) * 1000);
    el.innerHTML = duration.map(function(n) { return 10 > n ? '0' + n : n; }).join(':');
  });
};

AudioPlayer.prototype.formatTrackPosition = function(el, property) {
  var binding = this;
  binding.change(function() {
    var trackPosition = binding.value(property) || 0;
    el.style.width = (trackPosition * 100) + "%";
  });
};

AudioPlayer.prototype.formatHandlePosition = function(el, property) {
  var binding = this;
  binding.change(function() {
    var trackPosition = binding.value(property) || 0;
    el.style.left = (this.model.elementWidth * trackPosition) + "px";
  });
};

AudioPlayer.prototype.onPlayClick = function(e) {
  e.preventDefault();
  this.player.play();
  this.view.set("playing", true);
};

AudioPlayer.prototype.onPauseClick = function(e) {
  e.preventDefault();
  this.player.pause();
  this.view.set("playing", false);
};

AudioPlayer.prototype.onTimeUpdate = function(e) {
  this.view.set("currentTime", this.player.currentTime);
  this.setPlayProgressByTime(this.model.currentTime);
};

AudioPlayer.prototype.setPlayProgressByTime = function(currentTime) {
  var duration = this.model.duration || 0;
  currentTime = currentTime || 0;
  var playProgress = currentTime / duration;
  this.view.set("playProgress", playProgress);
  this.view.set("trackPosition", playProgress);
};

AudioPlayer.prototype.setHandlePosition = function() {
  // Set the trackPosition and the playProgress based on % across
  var percentagePosition = this.handleEl.offsetLeft / this.model.elementWidth;
  percentagePosition = (percentagePosition > 1) ? 1 : percentagePosition;
  this.view.set("playProgress", percentagePosition);
  this.view.set("trackPosition", percentagePosition);
  return percentagePosition;
};

AudioPlayer.prototype.onHandleDrag = function(e) {
  var percentagePosition = this.setHandlePosition();
};

AudioPlayer.prototype.onHandleDragEnd = function(e) {
  var percentagePosition = this.setHandlePosition();
  // Set the playing time
  this.player.currentTime = this.model.duration * percentagePosition;
};

// Export the creation function
module.exports = AudioPlayer;
