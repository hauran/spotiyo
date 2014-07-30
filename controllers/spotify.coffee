request = require "request"
querystring = require 'querystring'
url = require "url"
_ = require 'lodash'
async = require 'async'
moment = require 'moment'
fs = require "fs"
path = require "path"
mime = require "mime"


if process.env.NODE_ENV is "production"
  redirect_uri = 'http://spotiyo-mgbzunisyp.elasticbeanstalk.com/callback'
else
  redirect_uri = 'http://localhost:8080/callback'

client_id = '5bc5d8c7b3f74d089b4cb08fee835e03'
client_secret = '4e7d3cea5c43431e8413fe298041c63d'
echo_nest_key = 'N7LTFGGV7RXYPBW1T'

exports.setup = (app) ->
  app.get "/login", (req, res) ->
    # your application requests authorization
    scope = "user-read-private user-read-email playlist-read-private playlist-modify playlist-modify-private"
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

  app.post "/playlists", (req, res) ->
    if req.cookies.expires_on > moment().unix()
      newPlaylist req,res
    else
      refreshTokens req, res, () ->
        newPlaylist req,res

  app.get "/playlists/:id/tracks", (req,res) ->
    if req.cookies.expires_on > moment().unix()
      getTracks req,res
    else
      refreshTokens req, res, () ->
        getTracks req,res

  app.get "/search/albumByArtist", (req,res) ->
    console.log "search albumByArtist #{req.query.q}"
    res.send 200

  app.get "/search/:type", (req,res) ->
    type = req.params.type
    q = req.query.q

    switch type
      when 'artist'
        options =
          url: "http://developer.echonest.com/api/v4/playlist/static?api_key=#{echo_nest_key}&artist=#{q}&format=json&results=1&type=artist&variety=0&bucket=id:spotify&bucket=tracks&limit=true"
          json: true
        request.get options, (error, response, body) ->
          res.send {song:body.response.songs[0]}
      when 'album'
        options =
          url: "https://api.spotify.com/v1/search?q=#{q}&type=album"
          json: true

        request.get options, (error, response, body) ->
          console.log body
          res.send 200






  app.get "/search", (req,res) ->
    console.log "search ", req
    url = "https://api.spotify.com/v1/search?q=#{req.query.q}&type=artist,album,track"
    request.get url, (error, response, body) ->
      res.send body


  app.get "/dropcity", (req,res) ->
    file = path.dirname(require.main.filename) + '/DropCity_iOS_APNs_Production.p12'
    filename = path.basename(file)
    mimetype = mime.lookup(file)

    res.setHeader('Content-disposition', 'attachment; filename=' + filename);
    res.setHeader('Content-type', mimetype);

    filestream = fs.createReadStream(file);
    filestream.pipe(res);
    # fs.read '/DropCity_iOS_APNs_Production.p12', (e,d)->
    #   res.send d



getPlaylists = (req,res) ->
  options =
    url: "https://api.spotify.com/v1/users/#{req.userId}/playlists"
    headers:
      Authorization: "Bearer #{req.access_token}"
    json: true
  request.get options, (error, response, body) ->
    res.send body

newPlaylist = (req,res) ->
  options =
    url: "https://api.spotify.com/v1/users/#{req.userId}/playlists"
    headers:
      Authorization: "Bearer #{req.access_token}"
    body:
      name: req.body.name
      public: "true"
    json: true

  request.post options, (error, response, body) ->
    res.send body


getTracks = (req,res) ->
  options =
    url: req.query.href
    headers:
      Authorization: "Bearer #{req.access_token}"
    json: true

  request.get options, (error, response, body) ->
    # console.log 'error', error
    # console.log 'response', response
    # console.log 'body', body
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
      res.send 500
