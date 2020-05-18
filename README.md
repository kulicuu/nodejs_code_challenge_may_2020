# Node.js Coding Challenge


## Assignment Spec:

The assignment specifies a microservice kind of API.  It's most precise to quote directly, so you can understand really the context.

> Create a restful API that returns the following data:
> 1. Return the information for one station given a station id
> 2. Given one or more stations, return the number of riders in the following age groups, [0-20,21-30,31-40,41-50,51+,unknown], who ended their trip at that station for a given day.
> 3. Given one or more stations, return the last 20 trips that ended at each station for a given day
> 4. Require every API request to include an API token and handle the case wher this is missing.
> 5. Add a test for at least one of the api calls.
> 6. Use whatever node packages you like but don't install 3rd party databases, caching, or other server apps.
> 7. Optimize the app as best as possible for performance and assume your app will run in a multiprocessor or multicore environment.
> 8. Setup your app so it can be run locally.
> **Really Nice To Have** Containerize your app so it can be deployed using Docker.
>
> **Data Sources:** Station Information. _This url should be called at least once by your app_
> https://gbfs.divvybikes.com/gbfs/en/station_information.json
>
> **Trip Data:** _The **unzipped** version of this data should be loaded from the filesystem into your app_
> https://s3.amazonaws.com/divvy-data/tripdata/Divvy_Trips_2019_Q2.zip
>
> **Resources** Divvy Data Home Page https://www.divvybikes.com/system-data
>
> **Submission**
> - Provide the source code to your project through a file or code repository
> [...]
> [README required]


## API Docs:

_rudimentary as this is a small prototype_

#### `GET /get_basic_token`
Returns you a token.
#### `POST /change_secret_token`
Those holding the admin-token can change the basic token with a new secret.
Requires `req.body.new_basic_token_secret`.
#### `POST /get_station_by_station_id`
Requires `req.body.station_id`
Returns stations information, spec item 1.
#### `POST /get_age_group_breakdown_by_stations_ids`
Requires `req.body.stations_ids` an array, and `req.body.date_str`, a string in format 4-digit-year, "-", 2-digit-month, "-", 2-digit-day.
Returns spec item 2.
#### `POST /get_last_twenty_trips_by_stations_ids`
Requires `req.body.stations_ids` an array.
Returns spec item 3.



###  Design Considerations:

The cost of lookup is constant to linear, because we have constructed convenient data-structures in a preliminary process completed before the service goes live.  
This could be space expensive, but our data set is manageable.  Of course irl we'd be using a dedicated data tool, and if necessary a more performant computational engine.
