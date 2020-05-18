# I don't remember so well the rules for idiomatically perfect REST semantics,
# so I'm going to just do something which I think is just as good if not better, a basic generic
# protocol on POST requests.



c = console.log.bind console
express = require 'express'
body_parser = require 'body-parser'
jwt = require 'express-jwt'
app = express()
json_parser = body_parser.json()



module.exports = ({
    service_status,
    get_station_by_station_id,
    get_age_group_breakdown_by_stations_ids,
    get_last_twenty_trips_by_stations_ids
}) ->
    { secret_token, admin_secret_token, service_ready } = service_status
    app.post '/change_secret_token',
    jwt { secret: admin_secret_token },
    (req, res) ->
        # TODO: Validate new secret token
        new_secret_token = req.body.new_secret_token
        secret_token = new_secret_token
        res.status(200).end()
    app.post '/get_station_by_station_id',
    jwt { secret: secret_token },
    (req, res) ->
        station_id = req.body.station_id
        # TODO: Perform use-case appropriate data integrity validations.
        res.send {
            station_id: station_id,
            station_info: (get_station_by_station_id station_id)
        }
        res.status(200).end()
    app.post '/get_age_group_breakdown_by_stations_ids',
    jwt { secret: secret_token },
    (req, res) ->
        stations_ids = req.body.stations_ids
        date_str = req.body.date_str
        res.send {
            stations_ids: stations_ids,
            age_group_breakdown_obj: (get_age_group_breakdown_by_stations_ids stations_ids, date_str)
        }
        res.status(200).end()
    app.post '/get_last_twenty_trips_by_stations_ids',
    jwt { secret: secret_token },
    (req, res) ->

        stations_ids = req.body.stations_ids
        res.send {
            stations_ids: stations_ids,
            last_twenty_trips_by_station_obj: (get_last_twenty_trips_by_stations_ids stations_ids)
        }
        res.status(200).end()












        app.listen 7000, '0.0.0.0'

        service_ready = true  # NOTE:  We could put the service online before the data processing is complete and return false or 'processing' for data-processing, that's what this is for, but not implemented now, not needed.  If you had long running computations prior to startup you might want some indication of progress.
