[![build](https://github.com/Ethorbit/Docker-Srcds/actions/workflows/docker-image.yml/badge.svg)](https://github.com/Ethorbit/Docker-Srcds/actions/workflows/docker-image.yml)
[![issues](https://img.shields.io/github/issues/Ethorbit/Docker-Srcds)](https://github.com/Ethorbit/Docker-Srcds/issues?q=is%3Aopen+is%3Aissue)

# steamcmd-server
An image based on [steamcmd](https://github.com/CM2Walki/steamcmd) designed for self-installing game servers. Server images can have their own App ID, start and update scripts. 

## Creating container from server image
`docker run -it --rm -v myserver:/home/steam/server <server image>`

## Creating new server image 
See the [existing implementations](servers) which are based on [steamcmd-server](Dockerfile)

Every directory inside is a separate docker image. 

### Environment variables
These variables should be used whereever possible.
* `USER`
* `HOMEDIR`
* `STEAMCMDDIR`
* `SERVERDIR`
* `UPDATESCRIPT`
* `STARTSCRIPT`

### Steps
* Change docker\_user inside the Makefile to your DockerHub's username.
* Create a new game image inside servers
* Build everything: `make build`
* Test it: `image=<name here> make test`
* Upload changes: `make push`
* [Create a pull request](https://github.com/Ethorbit/Docker-Srcds/pulls) to add it here
