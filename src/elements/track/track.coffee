Polymer 'yo-track',
  artist:''
  name:''
  imgsrc:''
  uri:''
  ready: ->
    @tracks = document.querySelector('yo-tracks')
    # @player = document.querySelector('yo-player')
  #
  # domReady: ->
  #   @tracks.setCurrentTrackPlaying()
  #
  playTrack: (evt) ->
    @fire 'trackclicked', {track:@number}

    # @tracks.playTrackNumber @number
    evt.preventDefault()
    evt.stopPropagation()
