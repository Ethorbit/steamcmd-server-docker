# WIP
This is currently being developed, **DO NOT** create server containers with it yet.

# Docker-Srcds
An image that installs an srcds server and runs it on container startup for the specified game.

### What's different about this than the others?
It not only installs the server you want, but also simultaneously updates and runs it on container start. All files are created at runtime, meaning you can mount the container to the host filesystem and easily manage the server there. See examples below.

### How do the auto updates work?
The server updates in the background after it launches, if it becomes outdated; simply restart it.

## Examples
