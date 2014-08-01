fs = require "fs"
path = require "path"
mime = require "mime"

exports.setup = (app) ->
  app.get "/dropcity", (req,res) ->
    file = path.dirname(require.main.filename) + '/DropCity_iOS_APNs_Production.p12'
    filename = path.basename(file)
    mimetype = mime.lookup(file)

    res.setHeader('Content-disposition', 'attachment; filename=' + filename);
    res.setHeader('Content-type', mimetype);

    filestream = fs.createReadStream(file);
    filestream.pipe(res);

  app.get "/pem", (req,res) ->
    file = path.dirname(require.main.filename) + '/DropCity_iOS_push_production.pem'
    filename = path.basename(file)
    mimetype = mime.lookup(file)

    res.setHeader('Content-disposition', 'attachment; filename=' + filename);
    res.setHeader('Content-type', mimetype);

    filestream = fs.createReadStream(file);
    filestream.pipe(res);#   res.send d
