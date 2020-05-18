c = console.log.bind console
fs = require 'fs'
{ promisify } = require 'util'
read_file = promisify fs.readFile
AGE_GROUPS =
    ZERO_TO_TWENTY: 'ZERO_TO_TWENTY'
    TWENTYONE_TO_THIRTY: 'TWENTYONE_TO_THIRTY'
    THIRTYONE_TO_FORTY: 'THIRTYONE_TO_FORTY'
    FORTYONE_TO_FIFTY: 'FORTYONE_TO_FIFTY'
    FIFTYONE_UP: 'FIFTYONE_UP'
    UNKNOWN: 'UNKNOWN'
quicksort = ( rayy ) ->
    if (rayy.length is 1) or (rayy.length is 0) then return rayy
    rand_idx = Math.floor(Math.random() * len)
    [pivot] = rayy.splice rand_idx, 1
    less = []
    more = []
    for trip, idx in rayy
        { score } = trip
        if score < pivot.score
            less.push trip
        else
            more.push trip
    less_sorted = quicksort less
    more_sorted = quicksort more
    less_sorted.concat pivot, more_sorted
counter = 0
age_group_by_yob_str = (yob_str) ->
    year_maybe = parseInt yob_str
    if isNaN(year_maybe)
        return AGE_GROUPS.UNKNOWN
    age_maybe = (new Date()).getFullYear() - year_maybe
    switch
        when age_maybe < 21
            return AGE_GROUPS.ZERO_TO_TWENTY
        when age_maybe < 31
            return AGE_GROUPS.TWENTYONE_TO_THIRTY
        when age_maybe < 41
            return AGE_GROUPS.THIRTYONE_TO_FORTY
        when age_maybe < 51
            return AGE_GROUPS.FORTYONE_TO_FIFTY
        when age_maybe < 50
            return AGE_GROUPS.FIFTYONE_UP
        else
            return AGE_GROUPS.UNKNOWN
parse_station_info = (json_str) ->
    JSON.parse(json_str).data.stations.reduce (acc, station, idx) ->
        acc[station.station_id] = (JSON.stringify station)
        acc
    , {}
ready_station_arq = -> new Promise (resolve) ->
    fp = '../../station_information.json'
    read_file fp, { encoding: 'utf8' }
        .then (text) ->
            resolve { result: (parse_station_info text) }
        .catch (err) ->
            c 'ERROR:', err
parse_item_two = (lines) ->
    lines.reduce (acc, line, idx) ->
        items = line.split ','
        yob_str = items[11]
        rider_age_group = age_group_by_yob_str yob_str
        rental_end_day = items[2].split(' ')[0]
        station_id = items[5]
        if not acc[station_id]
            acc[station_id] = {}
        if not acc[station_id][rental_end_day]
            acc[station_id][rental_end_day] =
                ZERO_TO_TWENTY: 0
                TWENTYONE_TO_THIRTY: 0
                THIRTYONE_TO_FORTY: 0
                FORTYONE_TO_FIFTY: 0
                FIFTYONE_UP: 0
                UNKNOWN: 0
        acc[station_id][rental_end_day][rider_age_group] += 1
        acc
    , {}
parse_item_three = (lines) ->
    lines.reduce (acc, line, idx) ->
        items = line.split ','
        station_id = items[5]
        rental_end_time = items[2]
        [ date, time ]= rental_end_time.split ' '
        [ year, month, day ] = date.split '-'
        [ hour, minute, second ]  = time.split ':'
        trip_score = (new Date(parseInt(year), parseInt(month), parseInt(day), parseInt(hour), parseInt(minute), parseInt(second))).getTime()
        if not acc[station_id]
            acc[station_id] = {
                top_20: {}
            }
        { top_20 } = acc[station_id]
        top_20.push
        { score: trip_score, trip_str: line }
        if top_20.length is 20
            top_20 = (quicksort top_20)
            top_20.shift()
        acc
    , {}
ready_trip_arq = -> new Promise (resolve) ->
    fp = '../../Divvy_Trips_2019_Q2/Divvy_Trips_2019_Q2'
    read_file fp, { encoding: 'utf8'}
    .then (text) ->
        lines = text.split '\n'
        lines = lines.filter (line, idx) ->
            line.split(',').length > 10
        resolve [ (parse_item_three lines), (parse_item_two lines) ]
    .catch (err) ->
        c 'ERROR:', err



exports.main = ->
    [ item_three, item_two ] = await ready_trip_arq()
    station_arq = await ready_station_arq()
    { item_three, item_two, station_arq }
