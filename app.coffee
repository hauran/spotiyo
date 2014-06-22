###
This is an example of a basic node.js script that performs
the Authorization Code oAuth2 flow to authenticate against
the Spotify Accounts.

For more information, read
https://developer.spotify.com/web-api/authorization-guide/#authorization_code_flow
###
express = require("express") # Express web server framework
request = require("request") # "Request" library
querystring = require("querystring")
client_id = "5bc5d8c7b3f74d089b4cb08fee835e03" # Your client id
client_secret = "ca041b7ba4ae4905a66cc6fc5b542ac5" # Your client secret
redirect_uri = "http://localhost:8888/callback" # Your redirect uri
app = express()
app.use express.static(__dirname + "/public")
app.get "/login", (req, res) ->
  
  # your application requests authorization
  scope = "user-read-private user-read-email"
  res.redirect "https://accounts.spotify.com/authorize?" + querystring.stringify(
    response_type: "code"
    client_id: client_id
    scope: scope
    redirect_uri: redirect_uri
  )
  return

app.get "/callback", (req, res) ->
  
  # your application requests refresh and access tokens
  code = req.query.code
  console.log code
  authOptions =
    url: "https://accounts.spotify.com/api/token"
    form:
      code: code
      redirect_uri: redirect_uri
      grant_type: "authorization_code"
      client_id: client_id
      client_secret: client_secret

    json: true

  console.log authOptions
  request.post authOptions, (error, response, body) ->
    console.log "!!!!", response.statusCode
    if not error and response.statusCode is 200
      access_token = body.access_token
      refresh_token = body.refresh_token
      options =
        url: "https://api.spotify.com/v1/me"
        headers:
          Authorization: "Bearer " + access_token

        json: true

      
      # use the access token to access the Spotify Web API
      request.get options, (error, response, body) ->
        console.log body
        return

      
      # we can also pass the token to the browser to make requests from there
      res.redirect "/#" + querystring.stringify(
        access_token: access_token
        refresh_token: refresh_token
      )
    return

  return

app.get "/refresh_token", (req, res) ->
  
  # requesting access token from refresh token
  refresh_token = req.query.refresh_token
  authOptions =
    url: "https://accounts.spotify.com/api/token"
    headers:
      Authorization: "Basic " + (new Buffer(client_id + ":" + client_secret).toString("base64"))

    form:
      grant_type: "refresh_token"
      refresh_token: refresh_token

    json: true

  request.post authOptions, (error, response, body) ->
    if not error and response.statusCode is 200
      access_token = body.access_token
      res.send access_token: access_token
    return

  return

console.log "Listening on 8888"
app.listen 8888