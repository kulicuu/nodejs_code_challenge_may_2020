# ROUGH DRAFT

# Node.js Coding Challenge


I'll manually transcribe the specs for this assignment in a later commit.  For now, I'm just adding this to show the path of the work.  The real work done is in src/main.coffee, the server.coffee in root folder was just a preliminary test of Docker.  I'll be using a custom Docker image though, so that's just scratch at this point.  In src/main.coffee at this point we have already implemented the core logic for requirements 1-3, which are the only ones that required anything computer-sciency, i.e. creating new data structures that will efficiently process the specified information.  These are one-time expense processes, that each service will run initially, before it is ready to go online.  The Docker container will need to be loaded with the divvy-data file, some specification on multi-core usage, and maybe a CoffeeScript interpreter.
