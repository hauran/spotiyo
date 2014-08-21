Polymer 'yo-playlist',
  ready: ->
    @playlists = document.querySelector('yo-playlists')
    @tracks = @shadowRoot.querySelector('yo-tracks')
    @player = document.querySelector('yo-player')
    @loading = true
    @justClosed = false
    @playing = false
    @expanded = false

    @tracks.addEventListener 'trackclicked', (e) =>
      @tracks.playTrackNumber e.detail.track

  play: ->
    @player.play()
    @playing = true

  pause: ->
    @player.pause()
    @playing = false

  domReady: ->
    @offset = @offsetTop + 20
    # hack - android browser doesnt render inline style
    @shadowRoot.querySelector('.mix').style.backgroundColor = @playlist.color
    @shadowRoot.querySelector('.smallHeader').style.backgroundColor = @playlist.color

  closePlaylist: ->
    @playlists.showAll()
    @shadowRoot.querySelector('.mix').style.webkitTransform = null
    window.scrollTo 0,@scrollY
    @expanded = false
    @showLittleHeader = false
    @removeEventListener 'down',false
    @removeEventListener 'track', false
    @removeEventListener 'up', false
    window.removeEventListener 'scroll', false
    @shadowRoot.querySelector('.mix .mixInfoContainer').removeAttribute 'touch-action'

  selectPlaylist: (evt) ->
    if !@expanded and !@justClosed
      @playlists.resetPlaying()
      @playlists.playing @
      @playlists.hideNotPlaying()
      @scrollY = window.scrollY
      setTimeout =>
        window.scrollTo 0,0
        @expanded = true
        @shadowRoot.querySelector('.mix').style.webkitTransform = "translateY(-#{@offset}px)"
        @shadowRoot.querySelector('.mix .mixInfoContainer').setAttribute 'touch-action','none'
        @makeMix()
        @listenForCloseSwipe()
      ,400

  listenForCloseSwipe: ->
      window.addEventListener 'scroll', (e) =>
        if window.scrollY > 160
          @showLittleHeader = true
        else
          @showLittleHeader = false

      @addEventListener 'down', (e) =>
        @point = new xPoint(e.clientY)

      @addEventListener 'track', (e) =>
        p = @point
        if p
          p.update e.clientY

      @addEventListener 'up', (e) =>
        p = @point
        return if !p
        if @expanded and p and p.isFlickDown()
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
