Polymer 'yo-player',
  play: (rtsp) ->
    Android.loadVideo rtsp

  ready: ->
    @playlist = document.querySelector('yo-playlist')
    @title = ''
    @active = false
    @noHeight = true
    @loading = true
    @playing = null
    # @trackIds = []
    @items = []

  play: (uri) ->
    try
      Android.play uri
    catch err
      console.log err

  getTracks: (id,href,uri) ->
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
      _this.play uri
      

  close:() ->
    @active = false
    _this = @
    _this.playlist.open()
    setTimeout ->
      _this.noHeight = true
    ,450
