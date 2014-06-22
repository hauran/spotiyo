Polymer 'yo-player',
  audio:null
  getToPlay: (toPlay) ->
    console.log('toPlay', toPlay)
    _this = @
    $.post '/searchTrack', {toPlay:toPlay}, (res) ->
      code = res.url.split('v=')[1].split('&')[0]
      _this.active = true
      _this.url  = "https://www.youtube.com/embed/#{code}?autoplay=1"

  stop: ->
    if @audio
      @audio.pause()

  ready: ->
    @url = ''
    @active = false
    @playlists = []
    @toPlay = _.debounce(@getToPlay,1000)
    
  close:() ->
    @active = false
  