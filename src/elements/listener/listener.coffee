Polymer 'yo-listener',
  player:document.querySelector 'yo-player'
  playlist:document.querySelector 'yo-playlist'
  tracks:document.querySelector 'yo-tracks'
  clear: ->
    clearTimeout @clearTO
    @clearTO = setTimeout( =>
      @listening = false
      @cancel = false
      @tryAgain = false
      @command=''
    , 300)
    return

  processCmd: (cmd) ->
    @listening = true
    @command = cmd
    orignal = words = cmd.toLowerCase().split(' ')
    if words[1] is 'playlist'
      if words[0] is 'new'
        words[0] = 'new playlist'
        words.splice(1,1)
      else if words[0] is 'play'
        words[0] = 'play playlist'
        words.splice(1,1)
    command = words.splice(0,1)[0]
    action = words.join(' ')

    switch command
      when "new playlist" then @newPlaylist action
      when "play" then
      when "add" then go relax
      when "playlist" then go iceFishing
      else @command = "Huh?"

    # @clear()

  newPlaylist:(name) ->
    $.post '/playlists', {name:name}, (res) =>
      console.log res
      @playlist.getPlayLists()
      @tracks.close()

  stopListening: ->
    @command=''
    @listening = false
    @cancel=false
    @tryAgain=false

  isListening: ->
    @command=''
    @listening = true
    @cancel=false
    @tryAgain=false

  tryAgainListening: ->
    @tryAgain = true
    setTimeout =>
      @isListening()
      Android.speak()
    ,500

  cancelListening: ->
    @cancel = true
    setTimeout =>
      @listening = false
      @clearTO = undefined
    ,500

  refresh: ->
    window.location.reload()

  toggle: ->
    Android.togglePlay()

  next: ->
    Android.next()

  ready: () ->
    @command = ''
    @cancel = false
    @tryAgain = false
    @listening = false
    @clearTO = undefined
