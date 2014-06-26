Polymer 'yo-track', 
  artist:''
  name:''
  imgsrc:''
  rtsp:''
  ready: ->
    @player = document.querySelector('yo-player')

  playTrack: ->
    @player.play @rtsp

