Polymer 'yo-player',
  play: (rtsp) ->
    Android.loadVideo rtsp

  ready: ->
    @playlist = document.querySelector('yo-playlist')
    @title = ''
    @active = false
    @noHeight = true
    @loading = true
    # @trackIds = []
    @items = []

  loadPlaylist: ->
    rtsps = []
    _.each @items, (item) ->
      rtsps.push item.rtsp

    Android.loadPlaylist rtsps.join()
    
  getTracks: (id,href) ->
    _this = @
    @noHeight = false
    @items = []
    @loading = true
    setTimeout ->
      $(window).scrollTop(0);
      _this.active = true
    ,350

    $.get "/playlists/#{id}/tracks", {href:href}, (res) ->
      _this.loading = false
      _this.items = res.items
      _this.loadPlaylist()

  close:() ->
    @active = false
    Android.hideVideo
    _this = @
    _this.playlist.open()
