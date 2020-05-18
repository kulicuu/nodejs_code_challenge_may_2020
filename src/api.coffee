# I'm preventing RESTful idioms here, that semantics can stay with the Express layer, just functions here.
c = console.log.bind console
module.exports = ->
    { item_three, item_two, station_arq } = await require('./data_prepare').main()
    get_station_by_station_id = (station_id) ->
        # This is returning a json string ready to be sent back to client; already string.
        station_arq[station_id]
    get_age_group_breakdown_by_stations_ids = (stations_ids, date) ->
        # Todo: document in API the semantics including the four bar separator
        # date is 4-digit-year folowwed by "-" then 2-digit month "-" then 2-digit day
        # This is returning a JS object
        stations_ids.reduce (acc, station_id, idx) ->
            acc["#{station_id}||||#{date}"] = item_two[station_id][date]
            acc
        , {}
    get_last_twenty_trips_by_stations_ids = (stations_ids) ->
        stations_ids.reduce (acc, station_id, idx) ->
            acc[station_id] = item_three[station_id].top_20
            acc
        , {}
    { get_station_by_station_id, get_age_group_breakdown_by_stations_ids, get_last_twenty_trips_by_stations_ids }
