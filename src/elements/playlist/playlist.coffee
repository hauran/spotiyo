Polymer 'yo-playlist',
  ready: ->
    @playlists = document.querySelector('yo-playlists')
    @tracks = @shadowRoot.querySelector('yo-tracks')
    @loading = true
    @justClosed = false

    @tracks.addEventListener 'trackclicked', (e) =>
      @tracks.playTrackNumber e.detail.track

  domReady: ->
    @offset = @offsetTop + 20
    # hack - android browser doesnt render inline style
    @shadowRoot.querySelector('.mix').style.backgroundColor = @playlist.color

  closePlaylist: ->
    @playlists.showAll()
    @shadowRoot.querySelector('.mix').style.webkitTransform = null
    @playing = false
    @removeEventListener 'down',false
    @addEventListener 'track', false
    @addEventListener 'up', false
    @shadowRoot.querySelector('.mix .mixInfoContainer').removeAttribute 'touch-action'

  selectPlaylist: (evt) ->
    if !@playing and !@justClosed
      @playlists.resetPlaying()
      @playlists.playing @
      @playing = true

      @shadowRoot.querySelector('.mix').style.webkitTransform = "translateY(-#{@offset}px)"
      @shadowRoot.querySelector('.mix .mixInfoContainer').setAttribute 'touch-action','none'

      $(window).scrollTop(0)
      @playlists.hideNotPlaying()
      @makeMix()
      @listenForCloseSwipe()

  listenForCloseSwipe: ->
      @addEventListener 'down', (e) =>
        @point = new xPoint(e.clientY)

      @addEventListener 'track', (e) =>
        p = @point
        if p
          p.update e.clientY

      @addEventListener 'up', (e) =>
        p = @point
        return if !p
        if @playing and p and p.isFlickDown()
          @closePlaylist()
          @justClosed = true
          setTimeout =>
            @justClosed = false
          ,500
        @point = null
        return false

  makeMix: ->
    @tracks.currentTrack = 0
    @tracks.items = []
    @tracks.loading = true
    @tracks.makeMix () =>
      @loading = false
    # $.get "/makeMix", {}, (res) =>
    #   @loading = false
    #   @tracks.loading = false
    #   @tracks.items = res.tracks
    #   @tracks.title = res.title

      # @playCurrentTrack()
      # @player.play()

    # console.log $pl
    # @tracks.makeMix()
