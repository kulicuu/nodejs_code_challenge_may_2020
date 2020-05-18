c = console.log.bind console
fs = require 'fs'
{ promisify } = require 'util'
read_file = promisify fs.readFile
tiny = require 'tiny-json-http'
service_status =
    service_ready: false
    basic_token_secret: 'placeholder_token_secret'
    admin_token_secret: 'placeholder_admin_token_secret'

f100 = ->
    # { get_station_by_station_id, get_age_group_breakdown_by_stations_ids, get_last_twenty_trips_by_stations_ids } = await (require './api')()
    #
    # await (require './service')({
    #     service_status,
    #     get_station_by_station_id,
    #     get_age_group_breakdown_by_stations_ids,
    #     get_last_twenty_trips_by_stations_ids
    # })


    opts =
        url: 'http://localhost:7000/get_basic_token'


    tiny.get opts, (err, data) ->
        if err
            c err
        c 'data', data
        c data.body, 'token?'
        basic_token = data.body

        opts3 =
            url: 'http://localhost:7000/get_age_group_breakdown_by_stations_ids'
            headers:
                Authorization: "Bearer #{basic_token}"
            data:
                stations_ids: ["5", "33", "35"]
                date_str: "2019-04-13"

        tiny.post opts3, (err, data) ->
            if err then c err
            c data.body.age_group_breakdown_obj, 'data0054895'

        opts4 =
            url: 'http://localhost:7000/get_last_twenty_trips_by_stations_ids'
            headers:
                Authorization: "Bearer #{basic_token}"
            data:
                stations_ids: ["5", "33", "35"]
        tiny.post opts4, (err, data) ->
            if err then c err
            c data.body.last_twenty_trips_by_station_obj["5"]


        opts2 =
            url: 'http://localhost:7000/get_station_by_station_id'
            headers:
                Authorization: "Bearer #{basic_token}"
            data:
                station_id: "35"

        tiny.post opts2, (err, data) ->
            if err
                c err
            c data, 'data2323'




f100()
