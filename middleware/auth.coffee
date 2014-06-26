moment = require 'moment'
_ = require 'lodash'
spotify = require('../controllers/spotify')

exports = module.exports = auth = () ->
  noAuth = ['login', 'callback', 'refreshToken', '']

  auth = (req, res, next) ->
    req.userId = req.cookies.userId
    req.access_token = req.cookies.access_token
    next()
    
    # route = req.url.split('/')[1].split('?')[0]
    # if _.indexOf(noAuth,route) isnt -1
    #   next()
    # else if req.cookies.expires_on && req.cookies.expires_on > moment().unix()
    #   req.userId = req.cookies.userId
    #   req.access_token = req.cookies.access_token
    #   next()
    # else
    #   spotify.refreshTokens req, res, ->
    #     next()

  