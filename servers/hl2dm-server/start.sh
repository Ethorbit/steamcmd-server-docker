#!/bin/bash
# Can't do autoupdate because a combination of the default game dir name 
# with spaces and the steamcmd runscript causes the srcds_run to completely break.
"${SERVER_DIR}/srcds_run" -game hl2mp +map dm_lockdown "${START_ARGS}"

