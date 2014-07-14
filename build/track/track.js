(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
Polymer('yo-track', {
  artist: '',
  name: '',
  imgsrc: '',
  uri: '',
  ready: function() {
    return this.tracks = document.querySelector('yo-tracks');
  },
  domReady: function() {
    if (this.number === 0) {
      return this.setAttribute("playing", "true");
    }
  },
  playTrack: function() {
    var currentPlaying;
    currentPlaying = document.querySelector('yo-tracks').shadowRoot.querySelector('[playing=true]');
    if (currentPlaying) {
      currentPlaying.shadowRoot.querySelector('.item-name').classList.remove('playing');
      currentPlaying.removeAttribute('playing');
    }
    this.setAttribute("playing", "true");
    this.shadowRoot.querySelector('.item-name').classList.add('playing');
    this.classList.add('playing');
    return this.tracks.play(this.uri);
  }
});


},{}]},{},[1])