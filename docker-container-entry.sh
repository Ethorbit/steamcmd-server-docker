#!/bin/bash
DIR=$(dirname -- $0)

if [ ! -z "$USER_ID" ]; then
    usermod -u $USER_ID srcds > /dev/null
fi

if [ ! -z "$GROUP_ID" ]; then
    groupmod -g $GROUP_ID srcds > /dev/null
fi

chown srcds -R "$DIR/"
chmod 770 -R "$DIR/"
exec runuser -u srcds -g srcds "$@"
