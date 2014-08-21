Polymer 'yo-track',
  artist:''
  name:''
  imgsrc:''
  uri:''
  ready: ->
    @tracks = document.querySelector('yo-tracks')
    @artist = @track.track.artists[0].name
    @name = @track.track.name
    @imgsrc = @track.track.album.images[1].url
    @uri = @track.track.uri
    @duration = @track.track.duration_ms
    @playlistUser = @track.friend
    @playlist = @track.playlist.name

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
