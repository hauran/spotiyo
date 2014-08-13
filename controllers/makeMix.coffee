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
#
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
#
exports.setup = (app) ->
  app.get "/makeMix", (req, res) ->
    mixTracks = []

    client.hget 'user_playlists', req.userId, (err, val) ->
      return false if err
      playlists = JSON.parse val
      _playlists = playlists.slice(0)  #clone

      (getTracks = ->
        playlist = _playlists.splice(0,1)[0] # get the first record of pl and reduce coll by one
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
                    mixTracks.push {playlist:playlist, track:track.track, track_info:track_info}
                catch err
                  # console.log 'err2', track.track.uri
                  client.hexists 'get_track_info_error',  track.track.uri,  (err,val) ->
                    if !val
                      client.hset 'get_track_info_error',  track.track.uri, 1, (err,val) ->
                      client.rpush 'get_track_info_job', "http://developer.echonest.com/api/v4/song/profile?api_key=#{echo_nest_key}&track_id=#{track.track.uri}&bucket=tracks&bucket=audio_summary&bucket=artist_discovery_rank&bucket=artist_hotttnesss_rank&bucket=song_type&bucket=song_hotttnesss_rank&&bucket=song_currency_rank&bucket=id:spotify"

                if _playlists.length is 0 and _tracks.length is 0
                  if mixTracks.length is 1254
                    console.log '1', mixTracks.length
                    final = shuffle(mixTracks)
                    final = final.splice(0,10)
                    returnMix = '\n'
                    console.log ('....................')

                    _.each final, (t) ->
                      returnMix += t.track_info.artist_name + ' - ' + t.track_info.title + '<br/>'
                    res.send 200, returnMix

                else
                  setTimeout getTrackInfo, 0
            )()

          catch err
            # console.log 'err1'
          if _playlists.length isnt 0
            setTimeout getTracks, 0
      )()

    # client.hget 'user_playlists', req.userId, (err, val) ->
    #   return false if err
    #   playlists = JSON.parse val
    #   _.each playlists, (p) ->
    #     client.hget 'playlist_tracks', p.id, (err, tracks) ->
    #       if err
    #         console.log 'err playlist_tracks', err
    #         return false
    #       try
    #         tracks = JSON.parse tracks
    #         # console.log '..........................\n\n'
    #         # console.log "### #{p.name} ###"
    #         _.each tracks, (t) ->
    #           track = t.track
    #           # console.log track.name, track.uri
    #           client.hget 'track_info', track.uri, (err, track_info) ->
    #             if err
    #               console.log 'err track_info', err
    #               return false
    #             try
    #               track_info = JSON.parse track_info
    #               delete track_info.tracks
    #               # console.log track_info
    #               if track_info.artist_hotttnesss_rank < 5500 or track_info.song_hotttnesss_rank < 35000 or track_info.artist_discovery_rank < 12500 or track_info.song_currency_rank < 6000
    #                 mixTracks.push {playlist:p, track:track, track_info:track_info}
    #                 console.log mixTracks.length
    #             catch err
    #               console.log 'track_info JSON ERROR', track.uri
    #       catch err
    #         console.log 'playlist_tracks JSON ERROR', p.name, p.uri

      # res.send 200
