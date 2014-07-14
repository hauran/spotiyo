Polymer 'yo-track',
  artist:''
  name:''
  imgsrc:''
  uri:''
  ready: ->
    @player = document.querySelector('yo-player')

  playTrack: ->
    currentPlaying = document.querySelector('yo-player').shadowRoot.querySelector('[playing=true]')
    if currentPlaying
      currentPlaying.shadowRoot.querySelector('.item-name').classList.remove('playing')
      currentPlaying.removeAttribute 'playing'

    this.setAttribute "playing", "true"
    this.shadowRoot.querySelector('.item-name').classList.add('playing')
    @classList.add 'playing'
    @player.play @uri
