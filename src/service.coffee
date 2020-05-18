# I don't remember so well the rules for idiomatically perfect REST semantics,
# so I'm going to just do something which I think is just as good if not better, a basic generic
# protocol on POST requests.
c = console.log.bind console
express = require 'express'
body_parser = require 'body-parser'
jwt = require 'jsonwebtoken'
app = express()
app.use body_parser.json()
{ blue, green, red, cyan, white } = require 'bash-color'
generate_basic_token = (token_secret) ->
    jwt.sign {
        user: "user"
    }, token_secret
module.exports = ({
    service_status,
    get_station_by_station_id,
    get_age_group_breakdown_by_stations_ids,
    get_last_twenty_trips_by_stations_ids
}) ->
    { basic_token_secret, admin_token_secret, service_ready } = service_status
    basic_access_token = generate_basic_token basic_token_secret
    admin_access_token = generate_basic_token admin_token_secret
    basic_auth = (req, res, next) ->
        auth_header = req.headers.authorization
        if auth_header
            candide_token = auth_header.split(' ')[1]
            jwt.verify candide_token, basic_token_secret, (err, user) ->
                if err
                    return res.sendStatus(403).end()
                req.user = user
                next()
        else
            res.sendStatus(401).end()
    admin_auth = (req, res, next) ->
        auth_header = req.headers.authorization
        if auth_header
            candide_token = auth_header.split(' ')[1]
            jwt.verify candide_token, admin_token_secret, (err, user) ->
                if err
                    return res.sendStatus(403).end()
                req.user = user
                next()
        else
            res.sendStatus(401).end()
    app.get '/get_basic_token',
    (req, res) ->
        (res.json basic_access_token).status(200).end()
    app.post '/change_secret_token',
    admin_auth,
    (req, res) ->
        # TODO: Validate new secret token
        new_basic_token_secret = req.body.new_basic_token_secret
        basic_access_token = generate_basic_token new_basic_token_secret
        basic_token_secret = new_basic_token_secret
        res.status(200).end()
    app.post '/get_station_by_station_id',
    basic_auth,
    (req, res) ->
        station_id = req.body.station_id
        # TODO: Perform use-case appropriate data integrity validations.
        res.send {
            station_id: station_id,
            station_info: (get_station_by_station_id station_id)
        }
        res.status(200).end()
    app.post '/get_age_group_breakdown_by_stations_ids',
    basic_auth,
    (req, res) ->
        stations_ids = req.body.stations_ids
        date_str = req.body.date_str
        res.send {
            stations_ids: stations_ids,
            age_group_breakdown_obj: (get_age_group_breakdown_by_stations_ids stations_ids, date_str)
        }
        res.status(200).end()
    app.post '/get_last_twenty_trips_by_stations_ids',
    basic_auth,
    (req, res) ->
        stations_ids = req.body.stations_ids
        res.send {
            stations_ids: stations_ids,
            last_twenty_trips_by_station_obj: (get_last_twenty_trips_by_stations_ids stations_ids)
        }
        res.status(200).end()
    app.listen 7000
    service_ready = true  # NOTE:  We could put the service online before the data processing is complete and return false or 'processing' for data-processing, that's what this is for, but not implemented now, not needed.  If you had long running computations prior to startup you might want some indication of progress.
    c (blue 'listening on port 7000', on)
