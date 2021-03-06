# Node.js Coding Challenge :: May 18 2020


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
Returns spec item 2, an object keyed by "<station_id>||||<date-str>", with values giving the age breakdown.
#### `POST /get_last_twenty_trips_by_stations_ids`
Requires `req.body.stations_ids` an array.
Returns spec item 3, an array of objects representing trips, with properties named `score`, which is the trip timestamp, and `trip_str`, which is the data-provided string of the trip.


###  Design Considerations:

The cost of lookup is constant to linear, because we have constructed convenient data-structures in a preliminary process completed before the service goes live.  
This could be space expensive, but our data set is manageable.  Of course irl we'd be using a dedicated data tool, and if necessary a more performant computational engine.

My tests suites at the unit level are only enough to facilitate implementation.  My paradigm in testing is that the major validations need to happen at integration level, [long discussion.].

In maintenance mode, I would have a more documented set of tests, but I would probably still just use basic Node scripts, rather than a testing library like.

A full top-level validation would feature a botnet, lots of edge cases, and whatever else the particular use-case irl might call for.

The API docs would be more fully developed irl.


### Note on Spec.7
As discussed above, the lookup time in normal service is trivial, there is only some cost on startup for processing data structures.  As far as multicore, these, can be run horizontally with pm2 fork or suchlike.  These are basically stateless and don't rely on each other, so multi-core multi-processor utilization is trivial.


### Docker Extra Credit

I did a Docker setup initially, but this is not compatible with my current setup.  I'm out of time, but might add the Docker setup later, even though myself I think it's more life-cycle appropriate after validation and once the production context is understood in all particulars.

The Docker image should contain the data file, NodeJS with CoffeeScript, and maybe PM2 for forking the process over cores.

This is not a difficult process but it can consume some time, especially as it will require more/different test routines to validate.

I may add this later.

### How To Run and How To Test

0. Basically, clone or move this repo into a folder containing the rider/trip data file.  So this project root is enclosed in a folder containing the data file.  You'll need a recent NodeJS engine and Coffeescript installed globally.
1. Make a top-level container folder. Move this repo into the top-level folder, or reclone it there.
2. Download and unzip the data file the top-level folder.
3. `npm i -g coffeescript`, and I like `npm i -g nodemon`
4. Go into /src.  `coffee main.coffee` will start the service.  It will say "Ready" in green when it is ready to serve.  There are some example requests that can be run (and modified as desired to look around) in /src/test222.coffee.  You can test the API at the logical level with /src/test111.coffee.  These are very hands-on tests, you are expected to modify them and examine the content in the console.  These are not automated test suite routines.  Run the scripts from in the /src folder.







### Why Is Not RESTful? and Other Concluding Remarks:


The spec explicitly called for a RESTful API, so what's up?  Did I not understand about REST? Was it too difficult?  Did I forget that part?  No. No. No.  I've been here and there in the industry, and peeked a bit into American corporate IT, and I've seen some examples of what I can only describe as technological cargo-cultisms, weird kind of collective hypnoses with respect to certain buzzwords, some messianic new pattern or build-tool.  For an articulated posiiton with respect to testing, check out a draft paper i'm working on: [Gist-Draft-Software-Testing](https://gist.github.com/kulicuu/538c9352817b923087f0e4f4f43c4e0e) discusses testing critical/mission-critical/life-critical network systems, and should be generally applicable the lower the threshold of acceptable operating failure for a given system.
With respect to REST specifically, I understand it solves some problems that apply to specific arrangements of tools capabilities.  In 2020, in the context of modern distributed system built on network-services "micro-services", it's completely irrelevant.  I could have easily implemented it over just one route, and have all the polymorphing/pivoting expressed through the JSON payload, it would make no operating difference.  With any API, a critical and necessary component is good clear documentation.  As long as I document my API well, and usage is consistent, there is no problem.  No need to waste precious mental cycles and billable hours on byzantine, ptolemeic, ancient superstitious practices with URLs.
I will say: If by chance, in a working situation, contract or job, if it is technically relevant or even if it's just to conform to institutional inertia, I will happily implement as RESTful an interface as you are willing to pay me for, but I'll never tell it was time well spent, unless there is some particular, and increasingly rare set of circumstances that would call for expressing everything in URL strings.
REST semantics, idiomatics, and the whole field is extremely tedious.  Also useless.
Since this is not a job but a coding-challenge, I'm obliged not to conform to anything, but to represent my professional judgement.  Even in a job, it would be worth providing constructive criticism as the company should have the intelligence to grow through inefficiencies in its process.  In real life, institutions, especially large ones, can develop ingrained habits of assumed technical ideology.  Software engineering is a young field, growing dynamically alongside its codependent technologies in hardware, and best practices are changing, people are trying to optimize and improve.  So, I try to offer an alternative perspective and reason about the factors I see as most relevant.  

_____________________________________


There are shortcomings in this service code, which is understandable for an example that was supposed to consume only some hours of worktime, never has had the attention given to it a production system would get.  Data-sets can grow, requiring streaming and specialized systems of data-transfer.  Compute loads can grow, might need to write an extension in Rust.  Security problems can manifest, might need to audit the control flow and potential vectors from input data, handle edge cases.  Testing and documentation for a maintenance-mode or pass-off needs to be written. Not a Mocha/Chai routine of a pile of trivial and redundant unit tests. Something comprehensive enough to familiarize a new developer with the design and operation, and them with an interface to assess operation and output.  Actual complete API documentation is a must. A full validation would require a top-level integration testing structure.  If this service is component of a distributed system, that system should already have one of those, so that would be wasted effort.  If it is the top-level, then this could be done, but again, how comprehensive it would be would depend on the particular use-case specifics.  Containerization is something I would consider a high-priority in a production context, but the particulars of the setup and orchestration can only be known with the particulars of the production and/or integration setup.
