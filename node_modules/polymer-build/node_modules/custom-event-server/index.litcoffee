This is a websocket, where we take over the lifecycle and compress it down
to the custom event interface.

    http = require 'http'
    WebSocketServer = require('ws').Server
    EventEmitter = require('events').EventEmitter
    yaml = require 'js-yaml'
    require 'colors'

    module.exports = (options) ->
      options = options or {}

This is our 'server' instance for clients.

      instance = new EventEmitter()
      instance.listen = (port) ->
        server.listen port or 8080
      server = http.createServer()
      wss = new WebSocketServer(server: server)

Bad news straight to the console.

      wss.on 'error', (error) ->
        console.error "#{error}".red

Scope out a per connection `client`.

      wss.on 'connection', (socket) ->
        if options.debug
          console.log 'connection'.green
        client =
          fire: (type, detail) ->
            message =
              type: type
              detail: detail or {}
            if options.debug
              console.log '<-'.blue
              console.log yaml.safeDump(message)
              console.log '---'.blue
            message = JSON.stringify(message)
            socket.send message, (err) ->
              if err
                console.log "#{err}".red
        client.fire 'hello'

Translate messages into events allowing declarative event handling.

        socket.on 'message', (req) ->
          try
            message = JSON.parse(req)
            if options.debug
              console.log '->'.blue
              console.log yaml.safeDump(message)
              console.log '---'.blue
            socket.clientid = message.clientid
            instance.emit message.type, message.type, message.detail, client
          catch error
            console.error "#{error}".red

      instance
