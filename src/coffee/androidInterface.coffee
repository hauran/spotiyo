back = () ->
  if listener.listening
    listener.listening = false
  else if playlist.active
    playlist.active = false
  else if tracks.active
    tracks.active = false
    playlist.active = true
  else
    try
      Android.homeButton()
    catch err
      console.log err
  return

playlists = document.querySelector("yo-playlists")
