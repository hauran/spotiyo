(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
Polymer('yo-listener', {
  player: document.querySelector('yo-player'),
  clear: function() {
    var _this;
    clearTimeout(this.clearTO);
    _this = this;
    this.clearTO = setTimeout(function() {
      _this.listening = false;
      _this.cancel = false;
      _this.tryAgain = false;
      return _this.command = '';
    }, 3000);
  },
  processCmd: function(command) {
    this.listening = true;
    this.command = command;
    return this.clear();
  },
  stopListening: function() {
    this.command = '';
    this.listening = false;
    this.cancel = false;
    return this.tryAgain = false;
  },
  isListening: function() {
    this.command = '';
    this.listening = true;
    this.cancel = false;
    return this.tryAgain = false;
  },
  tryAgainListening: function() {
    var _this;
    this.tryAgain = true;
    _this = this;
    return setTimeout(function() {
      _this.isListening();
      return Android.speak();
    }, 500);
  },
  cancelListening: function() {
    var _this;
    this.cancel = true;
    _this = this;
    return setTimeout(function() {
      _this.listening = false;
      return _this.clearTO = void 0;
    }, 500);
  },
  refresh: function() {
    return window.location.reload();
  },
  toggle: function() {
    return Android.togglePlay();
  },
  next: function() {
    return Android.next();
  },
  ready: function() {
    this.command = '';
    this.cancel = false;
    this.tryAgain = false;
    this.listening = false;
    return this.clearTO = void 0;
  }
});


},{}]},{},[1])