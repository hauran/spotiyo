<script>var back, playlists;

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

playlists = document.querySelector("yo-playlists");
</script>