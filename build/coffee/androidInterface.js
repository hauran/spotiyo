<script>var back, cancelListening, listener, listening, playlist, setPlaying, skipNext, spoken, tracks;

spoken = function(words) {
  listener.command = words;
};

listening = function() {
  listener.isListening();
};

cancelListening = function() {
  listener.stopListening();
};

setPlaying = function() {
  tracks.setPlaying();
};

skipNext = function() {
  tracks.skipNext();
};

back = function() {
  var err;
  if (listener.listening) {
    listener.listening = false;
  } else if (playlist.active) {
    playlist.active = false;
  } else if (tracks.active) {
    tracks.active = false;
    playlist.active = true;
  } else {
    try {
      Android.homeButton();
    } catch (_error) {
      err = _error;
      console.log(err);
    }
  }
};

listener = document.querySelector("yo-listener");

tracks = document.querySelector("yo-tracks");

playlist = document.querySelector("yo-playlist");
</script>