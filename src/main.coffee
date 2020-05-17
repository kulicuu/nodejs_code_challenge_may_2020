c = console.log.bind console
fs = require 'fs'
{ promisify } = require 'util'
read_file = promisify fs.readFile


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

f50 = ->
    fp = '../../Divvy_Trips_2019_Q2/Divvy_Trips_2019_Q2'
    read_file fp, { encoding: 'utf8'}
        .then (text) ->
            # c 'CONTENT:', text

            # c(text[0..200])


            x00 = text.split('\n')

            x00[0].split(',').map (item) ->
                c item


            # in some cases the age information is not available.


            # for idx in [15000..15600]
            #     c x00[idx]



            c 'done'
        .catch (err) ->
            c 'ERROR:', err

f50()


#  So when this thing starts it should start a web server immediately that can be hit by a monitor service to check if this one is active and ready.  so this server needs to store its state in that sense.  we need to build some data structures, so that they can be accessed most speedily.

# given the station info json, we create an object (not too much memory) keyed by station id, with value the already stringified json ready to send out.  that will be performant.
parse_station_info = (json_str) ->
    JSON.parse(json_str).data.stations.reduce (acc, station, idx) ->
        # c 'station', station.id
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
f70 = ->
    # This is an efficient data structure for serving Spec item 1. The function responsible for the data structure is parse_station_info
    await station_arq = ready_station_arq()
# f70()




# So now lets make an efficient data structure for item 2.

# for data-structure-two
# station_obj_f = ->




# stations on top, dates 2nd layer.
# So with this data structure it is trivial to make a function
# that takes a station-id and a date in that format 4digityear-two-digit-month-two-digit day and returns the number of trips ended there.
# This is most of the req for item-2, will need to wrap in a routine that iterates over the list of stations given.
parse_item_two = (text) ->
    lines = text.split '\n'
    lines.reduce (acc, line, idx) ->
        items = line.split ','
        unless items.length < 10
            rental_end_day = items[2].split(' ')[0]
            station_id = items[5]
            if not acc[station_id]
                acc[station_id] = {}
            if not acc[station_id][rental_end_day]
                acc[station_id][rental_end_day] = 1
            else
                acc[station_id][rental_end_day] += 1
        acc
    , {}


parse_item_three = (lines) ->
    lines.reduce (acc, line, idx) ->
        items = line.split ','
        station_id = items[5]
        rental_end_time = items[2]
        if idx < 10
            c rental_end_time
        # x33 = new Date(rental_end_time)
        # c x33

        # new Date(year, month, day, hour, minute, seconds)

        [ date, time ]= rental_end_time.split ' '
        [ year, month, day ] = date.split '-'
        [ hour, minute, second ]  = time.split ':'

        if idx < 10
            c hour, minute, second
        trip_score = (new Date(parseInt(year), parseInt(month), parseInt(day), parseInt(hour), parseInt(minute), parseInt(second))).getTime()
        # if idx < 10
            # c x33
        if not acc[station_id]
            acc[station_id] = {
                top_20: {}
            }
        { top_20 } = acc[station_id]
        # if acc[station_id].top_20.length < 20
        #     acc[station_id].top_20.push
        #     { score: trip_score, trip_str: line }
        top_20.push
        { score: trip_score, trip_str: line }
        if top_20.length is 20
            top_20 = (quicksort top_20)
            top_20.shift()
        acc
    , {}

ready_trip_arq = -> new Promise (resolve_all) ->
    fp = '../../Divvy_Trips_2019_Q2/Divvy_Trips_2019_Q2'
    read_file fp, { encoding: 'utf8'}
    .then (text) ->
        lines = text.split '\n'
        lines = lines.filter (line, idx) ->
            line.split(',').length > 10
        promise_393 = new Promise (resolve) ->
            resolve (parse_item_three lines)
        promise_394 = new Promise (resolve) ->
            resolve (parse_item_two text)

        Promise.all [promise_393, promise_394]
            .then (values) ->
                resolve_all values
    .catch (err) ->
        c 'ERROR:', err


f99 = ->
    x56 = await ready_trip_arq()

    c Object.keys(x56)
    item_three = x56[0]
    item_two = x56[1]

f99()
