c = console.log.bind console
fs = require 'fs'
{ promisify } = require 'util'
read_file = promisify fs.readFile

f99 = ->
    { get_station_by_station_id, get_age_group_breakdown_by_stations_ids, get_last_twenty_trips_by_stations_ids } = await (require './api')()
    { item_three, item_two, station_arq } = await require('./data_prepare').main()
    # c item_three["026"].top_20, 'item_three'
    fp = '../../station_information.json'
    read_file fp, { encoding: 'utf8' }
        .then (text) ->
            stations = JSON.parse(text).data.stations
            c stations[0..2]
            some_stations_ids = stations[20..32].map (station) -> station.station_id
            # c ids, 'ids'
            some_station_id = some_stations_ids[5]
            some_stat = item_two[some_station_id]
            # c some_stat
            c Object.keys(some_stat).length

            some_date = "2019-06-29"

            # c item_two[some_station_id][some_date], 'item_two[some_station_id][some_date]'
            #
            #
            # c '\n\n'
            #
            # c (get_age_group_breakdown_by_stations_ids some_stations_ids, some_date), 'c (get_age_group_breakdown_by_stations_ids some_stations_ids, some_date),'

            c (get_last_twenty_trips_by_stations_ids some_stations_ids), 'c (get_last_twenty_trips_by_stations_ids some_stations_ids)'


            c JSON.parse(get_station_by_station_id "112"), 'c (get_station_by_station_id some_station_id)'


        .catch (err) ->
            c 'ERROR:', err














f99()
