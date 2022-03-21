[![build](https://github.com/Ethorbit/Docker-Srcds/actions/workflows/docker-image.yml/badge.svg)](https://github.com/Ethorbit/Docker-Srcds/actions/workflows/docker-image.yml)
[![issues](https://img.shields.io/github/issues/Ethorbit/Docker-Srcds)](https://github.com/Ethorbit/Docker-Srcds/issues?q=is%3Aopen+is%3Aissue)

# ![DockerHub](https://i.imgur.com/tItmtNW.png) [Docker Srcds](https://hub.docker.com/repository/docker/ethorbit/srcds-server)
A docker image that installs and runs an srcds server for the specified game.

### What's different about this than the others?
* All files are created at runtime, meaning you can mount the container to the host filesystem and easily manage the server there. (See examples below)

* Automatic updating is setup by default

* There's full terminal interactivity support, for example: if you press hotkey combos like Ctrl+l; it will be processed properly. This is because all the required libraries are present, unlike with other installs.

## Examples
* Creating a Garry's Mod server
```docker run -dit --env SRCDS_APPID=4020 --network host --restart always --name "my-gmod-server" ethorbit/srcds-server:latest```

* Creating a Garry's Mod server with run args
```docker run -dit --env SRCDS_APPID=4020 --env SRCDS_RUN_ARGS='-tickrate 66 +gamemode "sandbox" +map "gm_construct"' --restart always --network host --name "my-gmod-server" ethorbit/srcds-server:latest```

* Creating a Garry's Mod server with run args which runs as my host user and mounting it somewhere in my home directory
```docker run -dit -v /home/ethorbit/Servers/my-gmod-server:/home/srcds/server --env SRCDS_APPID=4020 --env SRCDS_RUN_ARGS='-tickrate 66 +rcon_password "mypass" +gamemode "sandbox" +map "gm_flatgrass"' --env USER_ID=1000 --env GROUP_ID=1000 --restart always --network host --name "my-gmod-server" ethorbit/srcds-server:latest```

* Using the console of a detached server: ```docker container attach "my-gmod-server"``` 

    You can press Ctrl+P, Ctrl+Q to detach again without closing the server

## Environment Variables
* `SRCDS_APPID`

This is the Steam game's appid that you want srcds to install. (See https://developer.valvesoftware.com/wiki/Steam_Application_IDs)


This can only be used on the first launch, but if you mount the container, you can modify the generated install.sh script.

* `SRCDS_RUN_ARGS`

These are the command line options (launch options and server commands) to run the server with, which contain: map, tick rate, rcon password, etc. (See https://developer.valvesoftware.com/wiki/Command_Line_Options)

These properties are inserted before your run args automatically: 
* -autoupdate
* -steam_dir
* -steamcmd_script

So don't pass them; mount the container and modify the generated start.sh script instead.

This can only be used on the first launch, but if you mount the container, you can always change it in start.sh.

* `USER_ID` `GROUP_ID`

The user and group ids that the docker container will run under. If you plan to mount the container to your system, you'll want this to match the user you plan to modify the files on (so that there's no permission issues), you can also add yourself to the USER_ID group to give yourself permissions.

* `SRCDS_AUTOVALIDATE`

This will validate files in the background when the server is started. 

Note: you do not need this for updates, srcds updates are automatic.

* `SRCDS_VALIDATE_INTERVAL`

The interval (in seconds) to validate the server files while it's running; it's set to 12 hours (43200) by default.

This only works if auto validating is enabled and can only be used on the first launch, but if you mount the container, you can modify the generated auto-validate.sh script.`

* `SRCDS_VALIDATE`

This is only useful if you have `SRCDS_AUTOVALIDATE` set to 0. Having this option set to 1 means when the container runs: a file validation process will take place, and the server won't start until it's done.

Unless for some reason your server keeps getting core components removed, there's no reason to enable this.
