#!/bin/sh
echo "TESTING"
DIR=$(dirname -- $0)
chown srcds -R "$DIR/"
exec runuser -u srcds -g srcds "$@" 
