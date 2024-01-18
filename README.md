[![build](https://github.com/Ethorbit/steamcmd-server-docker/actions/workflows/docker-image.yml/badge.svg)](https://github.com/Ethorbit/steamcmd-server-docker/actions/workflows/docker-image.yml)
[![issues](https://img.shields.io/github/issues/Ethorbit/steamcmd-server-docker)](https://github.com/Ethorbit/steamcmd-server-docker/issues?q=is%3Aopen+is%3Aissue)

# steamcmd-server
[A Docker image](Dockerfile) based on [steamcmd](https://github.com/CM2Walki/steamcmd) designed for self-installing game servers. [Server images](servers) can have their own App ID, start and update scripts. 

See the [existing implementations](servers)

## Creating container from [existing server image](servers)
`make build`

`docker run -it --rm -e START_ARGS="" -p 27015:27015/tcp -p 27015:27015/udp -v myserver:/home/steam/Steam/steamapps/common <server image>`

Add `-e STEAMCMD_LOGIN_USERNAME=username-here` and interactively login on first run if you get a susbcription or owner error.

You can also look for pre-built images [here](https://hub.docker.com/u/ethorbit).

## Creating new server image 

### Steps
* Create a new game directory inside servers/ (this doubles as the image name)
* Build everything: `make build`
* Test it: `image=<name here> make test`
* If a login error is received during testing, test using a Steam account that owns the content: `image=<name here> options='-e STEAMCMD_LOGIN_USERNAME=yoursteamname' make test`
* Upload changes by changing the Makefile's docker\_user to match your DockerHub username and running: `make push`
* [Create a pull request](https://github.com/Ethorbit/steamcmd-server-docker/pulls) to add the image to this repo.

### Environment variables
These variables should be used whereever possible.
* `USER`
* `HOME_DIR`
* `STEAMCMD_DIR`            - where steamcmd binaries are
* `SERVERS_DIR`             - where the server(s) that are installed go
* `SERVER_DIR`              - the server that is going to run
* `SHARED_DIR`              - shared directory, symlinks are automatically created to point to these files in the SERVERS\_DIR
* `IMAGE_DIR`               - where files baked into the server image are (like a start or update script), they are copied to SERVER\_DIR on container start
* `STEAMCMD_LOGIN_USERNAME` - the steam username of the account that owns the game
* `STEAMCMD_UPDATE_SCRIPT`  - txt update file using steamcmd update syntax
* `STEAMCMD_APPEND_SCRIPT`  - txt update file that is appended to the default txt file (instructions are run after login)
* `UPDATE_SCRIPT`           - shell script that executes STEAMCMD\_UPDATE\_SCRIPT
* `START_SCRIPT`            - shell script to start the game server
* `START_ARGS`              - arguments of the server executable which would be read in START\_SCRIPT
* `APP_ID`                  - game server's appid
