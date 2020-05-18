c = console.log.bind console
{ blue, green, red, cyan, white } = require 'bash-color'

initialize = ->
    c (cyan "Initializing... takes less than a minute...", on)
    service_status =
        service_ready: false
        basic_token_secret: 'placeholder_token_secret'
        admin_token_secret: 'placeholder_admin_token_secret'
    { get_station_by_station_id, get_age_group_breakdown_by_stations_ids, get_last_twenty_trips_by_stations_ids } = await (require './api')()
    await (require './service')({
        service_status,
        get_station_by_station_id,
        get_age_group_breakdown_by_stations_ids,
        get_last_twenty_trips_by_stations_ids
    })
    c (green "Ready", on)

initialize()
