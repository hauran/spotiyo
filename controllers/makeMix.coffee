request = require "request"
_ = require 'lodash'
async = require 'async'
moment = require 'moment'
nconf = require "nconf"
redis = require 'redis'
shuffle = require('knuth-shuffle').knuthShuffle

nconf.file 'file': './config/config.json'
if process.env.NODE_ENV is "production"
  port = nconf.get('redis:port')
  host = nconf.get('redis:host')
  client = redis.createClient(port, host)
else
  client = redis.createClient()

echo_nest_key = nconf.get('echo_nest:key')

# http://developer.echonest.com/acoustic-attributes.html

# insertCollection = (collection, callback) ->
#   coll = collection.slice(0) # clone collection
#   (insertOne = ->
#     record = coll.splice(0, 1)[0] # get the first record of coll and reduce coll by one
#     db.insert record, (err) ->
#       if err
#         callback err
#         return
#       if coll.length is 0
#         callback()
#       else
#         setTimeout insertOne, 0
#       return
#
#     return
#   )()
#   return

exports.setup = (app) ->
  app.get "/makeMix", (req, res) ->
    mixTracks = []
    client.lrange "#{req.userId}_friends", 0, -1,  (err, friends) ->
      done = false #kind of a hack
      return false if err
      # console.log friends
      _friends = friends.slice(0)  #clone
      (getFriendsPlaylist = ->
        friend = _friends.splice(0,1)[0] # get the first record of pl and reduce coll by one
        # console.log 'friend', friend
        client.hget 'user_playlists', friend, (err, val) ->
          return false if err
          playlists = JSON.parse val
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
                      returnMix = []
                      _.each final, (t) ->
                        # console.log t
                        returnMix.push "<a href='#{t.track.preview_url}'>#{t.track_info.artist_name} - #{t.track_info.title}</a> (#{t.friend} <a href='#{t.playlist.href}'>#{t.playlist.name}</a>)"
                      res.send 200, returnMix.join('<br/>')
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
