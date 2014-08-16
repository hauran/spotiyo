request = require "request"
_ = require 'lodash'
async = require 'async'
moment = require 'moment'
nconf = require "nconf"
redis = require 'redis'
randomWords = require 'random-words'
shuffle = require('knuth-shuffle').knuthShuffle

access_token = "hello"
access_token
spotify = {
  token:'hello'
  expires_on:'8/14/2014'

}

nconf.file 'file': './config/config.json'
if process.env.NODE_ENV is "production"
  port = nconf.get('redis:port')
  host = nconf.get('redis:host')
  client = redis.createClient(port, host)
else
  client = redis.createClient()

echo_nest_key = nconf.get('echo_nest:key')

# http://developer.echonest.com/acoustic-attributes.html

newPlaylist = (req,res) ->
  options =
    url: "https://api.spotify.com/v1/users/everyonesmixtape/playlists"
    headers:
      Authorization: "Bearer #{access_token}"
    body:
      name: 'test'
      public: "true"
    json: true

  request.post options, (error, response, body) ->
    res.send body

refreshTokens = (req,res,callback) ->
  authOptions =
    url: 'https://accounts.spotify.com/api/token'
    headers:
      'Authorization': 'Basic ' + (new Buffer(client_id + ':' + client_secret).toString('base64'))
    form:
      grant_type: 'refresh_token'
      refresh_token: req.cookies.refresh_token
    json: true

  request.post authOptions, (error, response, body) ->
    console.log 'refreshed'
    if !error and response.statusCode is 200
      access_token = body.access_token
      expires_in = body.expires_in
      expires_on = moment().add('s', expires_in).unix()
      req.access_token = access_token
      res.cookie 'access_token', access_token, {path:'/'}
      res.cookie 'expires_on', expires_on, {path:'/'}
      callback()
    else
      console.log 'refreshTokens', error
      res.send 500


exports.setup = (app) ->
  app.get "/makeamix", (req, res) ->
    if req.cookies.expires_on > moment().unix()
      newPlaylist req,res
    else
      refreshTokens req, res, () ->
        newPlaylist req,res

  app.get "/makeMix", (req, res) ->
    mixTracks = []
    client.lrange "#{req.userId}_friends", 0, -1,  (err, friends) ->
      done = false #kind of a hack
      return false if err
      # console.log friends
      _friends = friends.slice(0)  #clone
      (getFriendsPlaylist = ->
        friend = _friends.splice(0,1)[0] # get the first record of pl and reduce coll by one
        console.log 'friend', friend
        client.hget 'user_playlists', friend, (err, val) ->
          return false if err
          playlists = JSON.parse val
          return false if !playlists
          _playlists = playlists.slice(0)
          (getTracks = ->
            playlist = _playlists.splice(0,1)[0]
            client.hget 'playlist_tracks', playlist.id, (err, tracks) ->

              try
                tracks = JSON.parse tracks
                _tracks = tracks.slice(0)

                (getTrackInfo = ->
                  track = _tracks.splice(0,1)[0]
                  return if !track
                  return if track.track.uri is 'spotify:track:null'

                  client.hget 'track_info', track.track.uri, (err, track_info) ->
                    try
                      track_info = JSON.parse track_info
                      delete track_info.tracks
                      if track_info.artist_hotttnesss_rank < 5500 or track_info.song_hotttnesss_rank < 35000 or track_info.artist_discovery_rank < 12500 or track_info.song_currency_rank < 6000
                        mixTracks.push {playlist:playlist, track:track.track, track_info:track_info, friend:friend}
                    catch err
                      # console.log 'err2', track.track.uri
                      client.hexists 'get_track_info_error',  track.track.uri,  (err,val) ->
                        if !val
                          client.hset 'get_track_info_error',  track.track.uri, 1, (err,val) ->
                          client.rpush 'get_track_info_job', "http://developer.echonest.com/api/v4/song/profile?api_key=#{echo_nest_key}&track_id=#{track.track.uri}&bucket=tracks&bucket=audio_summary&bucket=artist_discovery_rank&bucket=artist_hotttnesss_rank&bucket=song_type&bucket=song_hotttnesss_rank&&bucket=song_currency_rank&bucket=id:spotify"

                    if !done and _playlists.length is 0 and _tracks.length is 0 and _friends.length is 0
                      done = true
                      final = shuffle(mixTracks)
                      final = final.splice(0,10)
                      title = randomWords({ min:2, max:5, join:' '})
                      title = title.replace(/\w\S*/g, (txt) ->
                        txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()
                      )
                      res.send 200, {title:title,tracks:final}
                    else
                      setTimeout getTrackInfo, 0
                )()

              catch err
                # console.log 'err1'
              if _playlists.length isnt 0
                setTimeout getTracks, 0
          )()

          # console.log 'err1'
        if _friends.length isnt 0
          setTimeout getFriendsPlaylist, 0
      )()
