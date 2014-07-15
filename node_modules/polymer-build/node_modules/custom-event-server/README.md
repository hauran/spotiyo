#Overview
I love the [CustomEvent](https://developer.mozilla.org/en-US/docs/Web/API/CustomEvent)
model in the DOM. A nice simple (name, detail) pairing. So, this is my take on
using that same model on the server. In my mind it fits with end-to-end
JavaScript to think about end-to-end events.

#Getting Started

##Install
```shell
npm install --save custom-event-server
```

###Simple Server
```coffeescript
server = require('custom-event-server')()
server.on 'beep', (name, detail, client) ->
  client.fire 'boop', {}
server.on 'woot', (name, detail, client) ->
  console.log 'ahhh!'
server.listen 8080
```

###Simple Client
This uses the [core-custom-event-client](https://github.com/Custom-Elements/core-custom-event-client)
which is a [Polymer](http://www.polymer-project.org/) element.

```html
<core-custom-event-client id="localhost" servers='ws://localhost:8080' onboop='this.server.fire("woot")'>
</core-custom-event-client>
```

And of course you can `addEventListener`, use a jQuery `on`, or bind a Polymer
style `on-boop='{{}}'`

#Theory
So the idea is that events coming from the server look and feel like events
coming from other DOM elements. And, that instead of RPC/REST/Messages, you
fire events on the server.

##Messages
This is really just a web socket, but it adopts a (name, detail) protocol. About
the only thing to keep in mind is to make sure your detail can be JSON serialized.

##Built Ins
### hello
Fired from the server back to your client on a connection or
reconnection.
### ping
Fired from the client `core-custom-event-client` element on a timer.
Pretty much any load balancer or proxy you put in front will time out and tear
down your web socket without this.
### pong
Fired from the server back to the client in response to a `ping`.
