c = console.log.bind console
fs = require 'fs'
{ promisify } = require 'util'
read_file = promisify fs.readFile










service_status =
    service_ready: false
    secret_token: 'placeholder_secret'
    admin_secret_token: 'placeholder_admin_secret'





f100 = ->
    { get_station_by_station_id, get_age_group_breakdown_by_stations_ids, get_last_twenty_trips_by_stations_ids } = await (require './api')()

    (require './service')({
        service_status,
        get_station_by_station_id,
        get_age_group_breakdown_by_stations_ids,
        get_last_twenty_trips_by_stations_ids
    })



f100()
