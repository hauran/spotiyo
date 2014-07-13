Polymer 'yo-track',
  artist:''
  name:''
  imgsrc:''
  uri:''
  ready: ->
    @player = document.querySelector('yo-player')

  playTrack: ->
    console.log @uri
    @player.play @uri
