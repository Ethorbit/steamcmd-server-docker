#!/bin/sh
DIR=$(dirname -- $0)
chown $(id -u $UID):$(id -g $GID) -R "$DIR/"
#chown srcds -R "$DIR/"
exec runuser -u srcds "$@" 
