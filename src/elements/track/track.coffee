Polymer 'yo-track', 
  artist:''
  name:''
  imgsrc:''
  ready: ->
    @player = document.querySelector('yo-player')
    @player.playFirst()

  playTrack: ->
    @player.play "#{@artist} - #{@name}"

