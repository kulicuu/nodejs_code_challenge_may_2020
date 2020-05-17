c = console.log.bind console












#  We probably want some statefullness.  Because initially the app cannot take calls.  idk, it won't necessarily be relevant but might.  will have to wait and see.  of course this is not a real production project, so maybe not.  we could introduce some just as a demonstration, which is what this all is anyway.

# We do need to understand the architectural context before we really know how to complete this microservice.  It needs to run at horizontal scale,















# Right now we don't need the express app, just need to load files and maybe hit


express = require 'express'






app = express()

app.get '/', (req, res) ->
    res.send 'hallo irving.'

app.listen 7000, '0.0.0.0'
