
# I'm preventing RESTful idioms here, that semantics can stay with the Express layer, just functions here.


c = console.log.bind console



module.exports = ->

    { item_three, item_two, station_arq } = await require('./data_prepare').main()


    get_station_by_station_id = (station_id) ->




    get_age_group_breakdown_by_stations_ids = (stations_ids) ->



    get_last_twenty_trips_by_stations_ids = (stations_ids) ->
        stations_ids.reduce (acc, station_id, idx) ->
            acc[station_id] = item_three.top_20
