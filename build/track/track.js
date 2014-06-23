(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
Polymer('yo-track', {
  info: null,
  ready: function() {
    this.artist = this.info.track.artists[0].name;
    this.name = this.info.track.name;
    this.imgSrc = this.info.track.album.images[2].url;
    this.player = document.querySelector('yo-player');
    return this.player.playFirst();
  },
  playTrack: function() {
    return this.player.play("" + this.artist + " - " + this.name);
  }
});


},{}]},{},[1])