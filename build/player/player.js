(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
Polymer('yo-player', {
  audio: null,
  getToPlay: function(toPlay) {
    var _this;
    console.log('toPlay', toPlay);
    _this = this;
    return $.post('/searchTrack', {
      toPlay: toPlay
    }, function(res) {
      var code;
      code = res.url.split('v=')[1].split('&')[0];
      _this.active = true;
      return _this.url = "https://www.youtube.com/embed/" + code + "?autoplay=1";
    });
  },
  stop: function() {
    if (this.audio) {
      return this.audio.pause();
    }
  },
  ready: function() {
    this.url = '';
    this.active = false;
    this.playlists = [];
    return this.toPlay = _.debounce(this.getToPlay, 1000);
  },
  close: function() {
    return this.active = false;
  }
});


},{}]},{},[1])