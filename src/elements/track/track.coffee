Polymer 'yo-track',
  artist:''
  name:''
  imgsrc:''
  uri:''
  ready: ->
    @tracks = document.querySelector('yo-tracks')
    
  domReady : ->
    if @number==0
      @setAttribute "playing", "true"

  playTrack: ->
    currentPlaying = document.querySelector('yo-tracks').shadowRoot.querySelector('[playing=true]')
    if currentPlaying
      currentPlaying.shadowRoot.querySelector('.item-name').classList.remove('selected')
      currentPlaying.removeAttribute 'playing'

    this.setAttribute "playing", "true"
    this.shadowRoot.querySelector('.item-name').classList.add('selected')
    @classList.add 'playing'
    @tracks.play @uri
