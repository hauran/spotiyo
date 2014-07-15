Polymer 'yo-tracks',
  ready: ->
    @playlist = document.querySelector('yo-playlist')
    @title = ''
    @active = false
    @loading = true
    @playing = null
    @items = []

  play: (uri) ->
    setTimeout ->
      document.querySelector('yo-player').shadowRoot.querySelector('.controls').classList.add('showControls')
    ,350
    try
      Android.play uri
    catch err
      console.log err

  getTracks: (id,href,uri) ->
    _this = @
    @items = []
    @loading = true
    @active = true
    $(window).scrollTop(0)

    $.get "/playlists/#{id}/tracks", {href:href}, (res) ->
      _this.loading = false
      _this.items = res.items
      _this.play uri

  close:() ->
    @active = false
    _this = @
    _this.playlist.open()
