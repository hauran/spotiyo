Polymer 'yo-login',
  loginClick: ->
    @active = true
    @login = 'hold on'

  ready: ->
    @url = ''
    @active = false
    @login = 'log in'
    @playlist = document.querySelector('yo-playlist')
    _this = @

    if $.cookie('userId')
      @active = true
      @login = 'hold on'
      @playlist.getPlayLists()
        