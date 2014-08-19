Polymer 'yo-playlists',
  ready: ->
    @active = false
    @playlists = []
    @playerShow = false
    # @tracks = document.querySelector('yo-tracks')
    @home = document.querySelector('yo-login')
    @currentlyPlaying = null

  resetPlaying: ->
    if @currentlyPlaying
      @currentlyPlaying.removeAttribute 'playing'

  hideNotPlaying: ->
    if @currentlyPlaying
      notPlaying = @shadowRoot.querySelectorAll('yo-playlist:not([playing])')
      $.each notPlaying, ()->
        $(@.shadowRoot.querySelector(".mix")).addClass 'invisible'
      @shadowRoot.querySelector('.header').style.visibility = 'hidden'

  showAll: ->
    @shadowRoot.querySelector('.header').style.visibility = null
    all = @shadowRoot.querySelectorAll('yo-playlist')
    $.each all, ()->
      $(@.shadowRoot.querySelector(".mix")).removeClass 'invisible'

  getPlayLists: ->
    window.addEventListener 'scroll', (e) =>
      if window.scrollY > 100
        @showMini = true
      else
        @showMini = false

    $.get '/spotify/playlists', (res) =>
    $.get '/mixes', (res) =>
      # @playlists = res.items
      @user = res.user
      @playlists = [
        {
          name:'Very Labor Steam Remain Better'
          date:'August 12 2014'
          tracks: 12
          starred:false
          friends: 10
          color:'#3498db'
        }
        {
          name:'Trick Sitting Dream Tobacco'
          date:'August 11 2014'
          tracks: 11
          starred:true
          friends: 15
          color:'#f1c40f'
        }
        {
          name: 'Short No Second'
          date:'August 10 2014'
          tracks: 9
          starred:true
          friends: 12
          color:'#e74c3c'
        }
        {
          name:'Darkness During Unusual Death Cutting'
          date:'August 9 2014'
          tracks: 14
          starred:false
          friends: 10
          color:'#34495e'
        }
        {
          name:'Doing Rhythm Tube'
          date:'August 8 2014'
          tracks: 13
          starred:false
          friends: 11
          color:'#e67e22'
        }
        {
          name:'Upper Four Tropical Chose'
          date:'August 7 2014'
          tracks: 8
          starred:true
          friends: 12
          color:'#3498db'
        }
        {
          name:'Amount Herself Wool'
          date:'August 6 2014'
          tracks: 10
          starred:true
          friends: 14
          color:'#f1c40f'
        }
        {
          name:'Thrown Appropriate Divide'
          date:'August 5 2014'
          tracks: 11
          starred:false
          friends: 13
          color:'#e74c3c'
        }
      ]

      @active = true
      setTimeout =>
        @home.loggedIn = true
        @home.active = false
      ,500

  playing:(pl) ->
    console.log pl
    @currentlyPlaying = pl
    pl.setAttribute 'playing', 'true'

  # star: (evt) ->
  #   $pl = $(evt.toElement)
  #   $pl.toggleClass('fa-star').toggleClass('fa-star-o')
  #   evt.stopPropagation()

  open: ->
    @active = true

  close:() ->
    @active = false
