





## To Do

- Docker container needs to be packaged with the data.


## Concept

we're going to have a cluster of these Docker containerized NodeJS micro-services, and there will be some load balancer proxy like Nginx which we'll leave out of scope.  All the DockerCompose and orchestration stuff would be another layer for a more articulated actual particular project specification.

so it loads the data from disk, it hits the url, loads that into memory.

it needs to take advantage of its multi-core system environment.  That's fine.
