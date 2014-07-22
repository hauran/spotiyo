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
    words = cmd.toLowerCase().split(' ')
    original = _.clone words

    command = words.splice(0,1)[0]
    action = words.join(' ').trim()
    words.splice(0,1)
    action2 = words.join(' ').trim()

    switch command
      when "play"
        switch original[1]
          when "artist" then @searchArtist action2
          when "album"
            if original[2] is "by"
              @searchAlbumByArtist action2
            else
              @searchAlbum action2
          when "track" then @searchTrack action2
          when "playlist" then @searchPlaylist action2
          else @search action
      when "new"
        if original[1] is "playlist"
          @newPlaylist action2
      when "add" then go relax
      when "playlist" then @searchPlaylist action
      else @command = "Huh?"

  searchArtist:(q) ->
    $.get "/search/artist?q=#{q}", (res) =>
      @tracks.play res.song.tracks[0].foreign_id
      @player.track res.song.title, res.song.artist_name

  searchAlbumByArtist:(q) ->
    $.get "/search/albumByArtist?q=#{q}", (res) =>
      console.log res

  searchTrack:(q) ->
    $.get "/search/track?q=#{q}", (res) =>
      console.log res

  searchAlbum:(q) ->
    $.get "/search/album?q=#{q}", (res) =>
      console.log res

  searchPlaylist:(q) ->
    $.get "/search/playlist?q=#{q}", (res) =>
      console.log res

  search:(q) ->
    $.get "/search?q=#{q}", (res) =>
      console.log res

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


  playArtist: ->
    @searchArtist "radiohead"

  playAlbum: ->
    @searchAlbum "Blank Sands"

  playTrack: ->
    @searchTrack "Poke"

  play: ->
    @search "Elephant Gun"

  ready: () ->
    @command = ''
    @cancel = false
    @tryAgain = false
    @listening = false
    @clearTO = undefined
