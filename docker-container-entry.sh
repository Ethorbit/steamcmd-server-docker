#!/bin/sh
DIR=$(dirname -- $0)
chown srcds:$USER -R $DIR/
exec runuser -u srcds "$@" 
