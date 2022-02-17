#!/bin/sh
DIR=$(dirname -- $0)
chown srcds -R "$DIR/"
exec runuser -u srcds "$@" 
