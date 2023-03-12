[![build](https://github.com/Ethorbit/steamcmd-server-docker/actions/workflows/docker-image.yml/badge.svg)](https://github.com/Ethorbit/steamcmd-server-docker/actions/workflows/docker-image.yml)
[![issues](https://img.shields.io/github/issues/Ethorbit/steamcmd-server-docker)](https://github.com/Ethorbit/steamcmd-server-docker/issues?q=is%3Aopen+is%3Aissue)

# steamcmd-server
[A Docker image](Dockerfile) based on [steamcmd](https://github.com/CM2Walki/steamcmd) designed for self-installing game servers. [Server images](servers) can have their own App ID, start and update scripts. 

See the [existing implementations](servers)

## Creating container from [existing server image](servers)
`make build`

`docker run -it --rm -p 27015:27015/udp -v myserver:/home/steam/server <server image>`

You can also look for pre-built images [here](https://hub.docker.com/u/ethorbit).

## Creating new server image 

### Steps
* Create a new game image inside servers/
* Build everything: `make build`
* Test it: `image=<name here> make test`
* Upload changes by changing the Makefile's docker\_user to match your DockerHub username and then run: `make push`
* [Create a pull request](https://github.com/Ethorbit/steamcmd-server-docker/pulls) to add the image to this repo.

### Environment variables
These variables should be used whereever possible.
* `USER`
* `HOME_DIR`
* `STEAMCMD_DIR`           - where steamcmd binaries are
* `SERVER_DIR`             - where the server installs
* `STEAMCMD_UPDATE_SCRIPT` - txt update file using steamcmd update syntax
* `UPDATE_SCRIPT`          - shell script that executes STEAMCMD\_UPDATE\_SCRIPT
* `START_SCRIPT`           - shell script to start the game server
* `APP_ID`                 - game server's appid
