Polymer 'yo-player',
  play: (toPlay) ->
    _this = @
    $.post '/searchTrack', {toPlay:toPlay}, (res) ->
      code = res.url.split('v=')[1].split('&')[0]
      _this.active = true
      _this.url  = "https://www.youtube.com/embed/#{code}?autoplay=1"

  ready: ->
    @playlist = document.querySelector('yo-playlist')
    @title = ''
    @active = false
    @noHeight = true
    @loading = true
    @state = 0
    @items = []
    
  getTracks: (id,href) ->
    _this = @
    @noHeight = false
    setTimeout ->
      $(window).scrollTop(0);
      _this.active = true
    ,350

    $.get "/playlists/#{id}/tracks", {href:href}, (res) ->
      _this.loading = false
      _this.items = res.items

  playFirst: ->
    return if @state is 1
    @state = 1
    @play "#{@items[0].track.artists[0].name} - #{@items[0].track.name}"

  close:() ->
    @active = false
    _this = @
    _this.playlist.open()
