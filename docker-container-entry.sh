#!/bin/sh
DIR=$(dirname -- $0)

if [ ! -z $USER_ID ]; then
    usermod -u $USER_ID srcds
fi

if [ ! -z $GROUP_ID ]; then
    groupmod -g $GROUP_ID srcds
fi

chown srcds -R "$DIR/"
exec runuser -u srcds -g srcds "$@"
