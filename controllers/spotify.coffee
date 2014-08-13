request = require "request"
querystring = require 'querystring'
url = require "url"
_ = require 'lodash'
async = require 'async'
moment = require 'moment'
fs = require "fs"
path = require "path"
mime = require "mime"
nconf = require "nconf"
redis = require 'redis'

nconf.file 'file': './config/config.json'

if process.env.NODE_ENV is "production"
  redirect_uri = 'http://spotiyo-mgbzunisyp.elasticbeanstalk.com/callback'
  port = nconf.get('redis:port')
  host = nconf.get('redis:host')
  client = redis.createClient(port, host)
else
  redirect_uri = 'http://localhost:8080/callback'
  client = redis.createClient()

client_id = nconf.get('spotify:client_id')
client_secret = nconf.get('spotify:client_secret')
echo_nest_key = nconf.get('echo_nest:key')

exports.setup = (app) ->
  app.get "/login", (req, res) ->
    # your application requests authorization
    scope = "user-read-private user-read-email playlist-read-private playlist-modify playlist-modify-private user-library-read user-library-modify  "
    res.redirect "https://accounts.spotify.com/authorize?" + querystring.stringify(
      response_type: "code"
      client_id: client_id
      scope: scope
      redirect_uri: redirect_uri
    )
    return

  app.get "/callback", (req, res) ->
    code = req.query.code
    authOptions =
      url: "https://accounts.spotify.com/api/token"
      form:
        code: code
        redirect_uri: redirect_uri
        grant_type: "authorization_code"
        client_id: client_id
        client_secret: client_secret
      json: true

    request.post authOptions, (error, response, body) ->
      if not error and response.statusCode is 200
        access_token = body.access_token
        refresh_token = body.refresh_token
        expires_in = body.expires_in
        expires_on = moment().add('s', expires_in).unix();

        options =
          url: "https://api.spotify.com/v1/me"
          headers:
            Authorization: "Bearer #{access_token}"
          json: true

        # use the access token to access the Spotify Web API
        request.get options, (error, response, body) ->
          userId = body.id
          options =
            url: "https://api.spotify.com/v1/users/#{userId}/playlists"
            headers:
              Authorization: "Bearer " + access_token
            json: true
          request.get options, (error, response, body) ->
            res.cookie 'access_token', access_token, {path:'/'}
            res.cookie 'refresh_token', refresh_token, {path:'/'}
            res.cookie 'expires_on', expires_on, {path:'/'}
            res.cookie 'userId', userId, {path:'/'}
            res.redirect "/"
      return
    return

  app.get "/playlists", (req, res) ->
    if req.cookies.expires_on > moment().unix()
      getPlaylists req,res
    else
      refreshTokens req, res, () ->
        getPlaylists req,res

getYourTracks = (req, res, pos) ->
  offset = pos * 50
  options =
    url: "https://api.spotify.com/v1/me/tracks?limit=50&offset=#{offset}"
    headers:
      Authorization: "Bearer #{req.access_token}"
    json: true

  request.get options, (error, response, body) ->
    client.hset 'user_tracks', req.userId, JSON.stringify(body.items), (err,val) ->
    #  GET TRACK INFO
    tracks = [];
    _.each body.items, (t) ->
      if t.track.id
        tracks.push t.track.uri

    if tracks.length > 0
      tracksParams = "&track_id=" + tracks.join('&track_id=')
      url = "http://developer.echonest.com/api/v4/song/profile?api_key=#{echo_nest_key}#{tracksParams}&bucket=tracks&bucket=audio_summary&bucket=artist_discovery_rank&bucket=artist_hotttnesss_rank&bucket=song_type&bucket=song_hotttnesss_rank&bucket=song_discovery_rank&&bucket=song_currency_rank&bucket=id:spotify"
      client.rpush 'get_track_info_job', url

    console.log 'getYourTracks', body.items.length, offset, pos
    if body.items.length is 50
      getYourTracks req, res, ++pos

getPlaylists = (req,res) ->
  getYourTracks req,res,0
  options =
    url: "https://api.spotify.com/v1/users/#{req.userId}/playlists"
    headers:
      Authorization: "Bearer #{req.access_token}"
    json: true

  request.get options, (error, response, body) ->
    res.send body
    client.hset 'user_playlists', req.userId, JSON.stringify(body.items), (err,val) ->
    getTracks = []
    _.each body.items, (p) ->
      tracksUri = p.tracks.href

      getTracks.push (callback) ->
        options =
          url: tracksUri
          headers:
            Authorization: "Bearer #{req.access_token}"
          json: true

        request.get options, (error, response, body) ->
          client.hset 'playlist_tracks', p.id, JSON.stringify(body.items), (err,val) ->

          #  GET TRACK INFO
          tracks = [];
          _.each body.items, (t) ->
            if t.track.id
              tracks.push t.track.uri

          if tracks.length > 0
            tracksParams = "&track_id=" + tracks.join('&track_id=')
            url = "http://developer.echonest.com/api/v4/song/profile?api_key=#{echo_nest_key}#{tracksParams}&bucket=tracks&bucket=audio_summary&bucket=artist_discovery_rank&bucket=artist_hotttnesss_rank&bucket=song_type&bucket=song_hotttnesss_rank&&bucket=song_currency_rank&bucket=id:spotify"
            client.rpush 'get_track_info_job', url
          callback null, p.id

    async.parallelLimit getTracks, 10, (err, results) ->
      console.log "DONE getTracks"

getTrackInfoJob = () ->
  client.llen 'get_track_info_job', (err, cnt) ->
    if cnt
      console.log 'getTrackInfoJob', cnt
      client.lpop 'get_track_info_job', (err,val) ->
        options =
          url: val
          json: true
        # console.log val
        request.get options, (error, response, body) ->
          console.log 'getTrackInfoJob ERROR', error if error
          if body.response.songs
            songs_idx = 0
            while songs_idx < body.response.songs.length
              s = body.response.songs[songs_idx]
              songs_idx++
              _s = _.cloneDeep s
              delete _s.tracks
              i = 0
              while i < s.tracks.length
                client.hset 'track_info', s.tracks[i].foreign_id, JSON.stringify(_s), (err,val) ->
                i++

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


setInterval getTrackInfoJob, 3500
