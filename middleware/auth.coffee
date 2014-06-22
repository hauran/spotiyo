exports = module.exports = auth = () ->
  auth = (req, res, next) ->
    req.userId = req.cookies.userId
    req.access_token = req.cookies.access_token

    next()  
  