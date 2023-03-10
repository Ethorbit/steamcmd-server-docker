[![build](https://github.com/Ethorbit/Docker-Srcds/actions/workflows/docker-image.yml/badge.svg)](https://github.com/Ethorbit/Docker-Srcds/actions/workflows/docker-image.yml)
[![issues](https://img.shields.io/github/issues/Ethorbit/Docker-Srcds)](https://github.com/Ethorbit/Docker-Srcds/issues?q=is%3Aopen+is%3Aissue)

# ![DockerHub](https://i.imgur.com/tItmtNW.png) [Docker Srcds](https://hub.docker.com/repository/docker/ethorbit/srcds-server)
A docker image that installs and runs an srcds server for the specified game.

### What's different about this than the others?
* All files are created at runtime, meaning you mount the container to the host filesystem and easily manage the server there. (See examples below)

* Automatic updating is setup by default

## Examples
* Creating a Garry's Mod server 
```docker run -dit -v /home/ethorbit/Servers/my-gmod-server:/home/srcds/server --user ethorbit:ethorbit --env SRCDS_APPID=4020 --env SRCDS_RUN_ARGS='-port 27015 -tickrate 66 +gamemode "sandbox" +map "gm_construct"' -p 27015:27015/udp --restart always --name "my-gmod-server" ethorbit/srcds-server:latest```

* Using the console of a detached server: ```docker container attach "my-gmod-server"``` 

    You can press Ctrl+P, Ctrl+Q to detach again without closing the server

## Build Arguments

* `PUID` `PGID`

The default UID and GID is set to 1000.

* `TZ`

The Timezone, which is set to "Etc/UTC" by default.

### Example:

`docker build --build-arg TZ="America/Los_Angeles" --build-arg PUID=420 --build-arg PGID=420 -t my-srcds-server ./`

## Environment Variables

* `UMASK`

Set the umask for files installed by steamcmd, which is '0027' by default.

* `SRCDS_RECURSIVE_FILE_PERMISSIONS`

Set the UMASK to all existing files before starting server. This is off by default, which means only files created during installation have the UMASK applied.

* `SRCDS_APPID`

This is the Steam game's appid that you want steamcmd to install. (See https://developer.valvesoftware.com/wiki/Steam_Application_IDs)


This can only be used on the first launch, but you can modify the generated update.sh script.

* `SRCDS_RUN_BINARY`

This is the name or relative path to the srcds server's start binary, it is usually called 'srcds_run' (which is the default). If your server doesn't start, change this.


This can only be used on the first launch, but you can modify the generated start.sh script.

* `SRCDS_RUN_ARGS`

These are the command line options (launch options and server commands) to run the server with, which contain: map, tick rate, rcon password, etc. (See https://developer.valvesoftware.com/wiki/Command_Line_Options)

These are already configured automatically: 
* -autoupdate
* -steam_dir
* -steamcmd_script

So don't pass them, modify the generated start.sh script instead.

This can only be used on the first launch, but you can always change it in start.sh.

* `SRCDS_AUTOVALIDATE`

(Off by default because of the CPU performance impact)
This will validate files in the background when the server is started. 

Note: you do not need this for updates, srcds updates should already be automatic.

* `SRCDS_VALIDATE_INTERVAL`

The interval (in seconds) to validate the server files while it's running; it's set to 12 hours (43200) by default.

This only works if auto validating is enabled and can only be used on the first launch, but if you mount the container, you can modify the generated auto-validate.sh script.`

* `SRCDS_VALIDATE`

This is only useful if you have `SRCDS_AUTOVALIDATE` set to 0. Having this option set to 1 means when the container runs: a file validation process will take place, and the server won't start until it's done.

Unless for some reason your server keeps getting core components removed, there's no reason to enable this.

## Solving startup issues 

Because all servers are different, sometimes system dependencies will be required which will not exist in this container. If a server has missing dependencies, it won't start or function correctly.

You can solve this in one of two ways:

<details>
    <summary>Manually</summary>


* Run `docker container exec -it container-name bash`
* Install & setup the required packages
* Try running container again 
</details>

<details>
    <summary>Automatically</summary>

    
There isn't a way to do this automatically, but you can create your own image which is based off of this one, and has the required dependencies [like done here for Sven Co-op](https://github.com/Ethorbit/svencoop-ds-docker)
</details>
