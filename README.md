[![build](https://github.com/Ethorbit/Docker-Srcds/actions/workflows/docker-image.yml/badge.svg)](https://github.com/Ethorbit/Docker-Srcds/actions/workflows/docker-image.yml)
[![issues](https://img.shields.io/github/issues/Ethorbit/Docker-Srcds)](https://github.com/Ethorbit/Docker-Srcds/issues?q=is%3Aopen+is%3Aissue)

# steamcmd-server
An image based on [steamcmd](https://github.com/CM2Walki/steamcmd) designed for self-installing game servers. Server images can have their own App ID as well as start and update scripts. 

## Creating a container from an existing server image
`docker run -it --rm -v myserver:/home/steam/server <server image>`

## Creating a new server image 
See the [existing implementations](servers) which are based on [steamcmd-server](Dockerfile)

Every directory inside is the name of the docker image. 

### Environment variables
These variables should be used whereever possible.
* `USER`
* `SERVERDIR`
* `UPDATESCRIPT`
* `STARTSCRIPT`

### Steps
* Change docker\_user inside the [Makefile](Makefile) to your DockerHub's username.
* Create an image to add support for a new game.
* Run `make build` to build every image.
* Run `image=<name here> make test` to ensure it works.
* Run `make push` to upload all the changes to DockerHub.
* Optionally create a pull request to add your image to this repo
