(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
Polymer('yo-player', {
  audio: null,
  getToPlay: function(toPlay) {
    var req, _this;
    console.log('toPlay', toPlay);
    _this = this;
    req = new XMLHttpRequest();
    req.open('GET', 'https://api.spotify.com/v1/search?type=track&q=' + encodeURIComponent(toPlay), true);
    req.onreadystatechange = function() {
      var data;
      if (req.readyState === 4 && req.status === 200) {
        data = JSON.parse(req.responseText);
        _this.stop();
        _this.audio = new Audio(data.tracks.items[0].preview_url);
        return _this.audio.play();
      }
    };
    return req.send(null);
  },
  stop: function() {
    if (this.audio) {
      return this.audio.pause();
    }
  },
  ready: function() {
    return this.toPlay = _.debounce(this.getToPlay, 1000);
  }
});


},{}]},{},[1])