(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
Polymer('yo-listener', {
  player: document.querySelector('yo-player'),
  clear: function() {
    var _this;
    clearTimeout(this.clearTO);
    _this = this;
    this.clearTO = setTimeout(function() {
      _this.listening = false;
    }, 3000);
  },
  cleanCommand: function(cmd, delimit) {
    return cmd.split(delimit)[1];
  },
  processCmd: function() {
    var cmd, toPlay;
    cmd = this.transcript.trim().toLowerCase();
    if ((this.listening && cmd.indexOf("play") === 0) || cmd.indexOf("yo play") === 0) {
      this.listening = true;
      toPlay = this.cleanCommand(cmd, 'play');
      this.command = "playing " + toPlay;
      this.player.toPlay(toPlay);
      this.clear();
    } else if (cmd.indexOf("yo") === 0 || cmd.indexOf("Yelp") === 0) {
      this.listening = true;
      this.command = "what up?";
      this.clear();
    } else if (cmd.indexOf("stop") === 0) {
      this.player.stop();
    }
  },
  listen: function() {
    var recognizer, _this;
    if (!("webkitSpeechRecognition" in window)) {
      return alert("Web speech API is not supported in this browser");
    } else {
      recognizer = new webkitSpeechRecognition();
      recognizer.continuous = true;
      recognizer.interimResults = true;
      recognizer.lang = ["English", ["en-US", "United States"]];
      _this = this;
      recognizer.onresult = function(e) {
        var i;
        _this.transcript = "";
        if (e.results.length) {
          i = event.resultIndex;
          while (i < event.results.length) {
            _this.transcript = event.results[i][0].transcript;
            _this.processCmd();
            i++;
          }
        }
      };
      return recognizer.start();
    }
  },
  ready: function() {
    this.transcript = "";
    this.clearTO = void 0;
    this.listening = false;
    return this.listen();
  }
});


},{}]},{},[1])