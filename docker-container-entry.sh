#!/bin/sh
DIR=$(dirname -- $0)
chown $(id -u $USER):$(id -g $USER) -R "$DIR/"
#chown srcds -R "$DIR/"
#exec runuser -u srcds "$@" 
