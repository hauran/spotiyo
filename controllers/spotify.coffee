request = require "request"
querystring = require 'querystring'
url = require "url"
ytSearch = require 'youtube-search'

# redirect_uri = 'http://localhost:3000/callback'

redirect_uri = 'http://yoplay-nqitaj4wnb.elasticbeanstalk.com/callback'
client_id = '5bc5d8c7b3f74d089b4cb08fee835e03'
client_secret = 'ca041b7ba4ae4905a66cc6fc5b542ac5'

exports.setup = (app) ->
  app.get "/login", (req, res) ->
    # your application requests authorization
    scope = "user-read-private user-read-email playlist-read-private"
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
        console.log body
        access_token = body.access_token
        refresh_token = body.refresh_token
        expires_in = body.expires_in

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
            res.cookie 'expires_in', expires_in, {path:'/'}
            res.cookie 'userId', userId, {path:'/'}
            res.redirect "/"
      return
    return

  app.get "/playlists", (req, res) ->
    options =
      url: "https://api.spotify.com/v1/users/#{req.userId}/playlists"
      headers:
        Authorization: "Bearer #{req.access_token}"
      json: true
    request.get options, (error, response, body) ->
      res.send body
      
  app.post "/searchTrack", (req, res, next) ->
    console.log req
    q = req.body.toPlay
    request.get "https://api.spotify.com/v1/search?type=track&q=#{q}",  (error, response, body) ->
      track =  JSON.parse(body).tracks.items[0]
      name = track.name 
      artist = track.artists[0].name

      ytSearch "#{artist} #{name}", {maxResults: 1, startIndex: 1}, (err, results)  ->
        if err 
          console.log 'err', err
          res.send 500
          
        res.send results[0]
