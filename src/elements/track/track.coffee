Polymer 'yo-track', 
  info:null
  ready: ->
    @artist = @info.track.artists[0].name
    @name = @info.track.name
    @imgSrc = @info.track.album.images[2].url
    @player = document.querySelector('yo-player')
    @player.playFirst()

  playTrack: ->
    @player.play "#{@artist} - #{@name}"

