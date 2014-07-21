spoken = (words) ->
  listener.processCmd words
  return
listening = ->
  listener.isListening()
  return
cancelListening = ->
  listener.stopListening()
  return
setPlaying = ->
  tracks.setPlaying()
  return
skipNext = ->
  tracks.skipNext()
  return
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

listener = document.querySelector("yo-listener")
tracks = document.querySelector("yo-tracks")
playlist = document.querySelector("yo-playlist")
