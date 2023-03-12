[![build](https://github.com/Ethorbit/Docker-Srcds/actions/workflows/docker-image.yml/badge.svg)](https://github.com/Ethorbit/Docker-Srcds/actions/workflows/docker-image.yml)
[![issues](https://img.shields.io/github/issues/Ethorbit/Docker-Srcds)](https://github.com/Ethorbit/Docker-Srcds/issues?q=is%3Aopen+is%3Aissue)

# steamcmd-server
[A Docker image](Dockerfile) based on [steamcmd](https://github.com/CM2Walki/steamcmd) designed for self-installing game servers. [Server images](servers) can have their own App ID, start and update scripts. 

See the [existing implementations](servers)

## Creating container from server image
`docker run -it --rm -p 27015:27015/udp -v myserver:/home/steam/server <server image>`

| Existing Images |
| --------------- |
| [gmod-server](https://hub.docker.com/r/ethorbit/gmod-server) |
| [svencoop-server](https://hub.docker.com/r/ethorbit/svencoop-server) |

## Creating new server image 

### Steps
* Change docker\_user inside the Makefile to your DockerHub's username.
* Create a new game image inside servers
* Build everything: `make build`
* Test it: `image=<name here> make test`
* Upload changes: `make push`
* [Create a pull request](https://github.com/Ethorbit/Docker-Srcds/pulls) to add it here

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
