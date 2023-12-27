#!/bin/bash
"${SERVER_DIR}/hlds_run" -autoupdate -steam_dir "${STEAMCMD_DIR}" -steamcmd_script "${SERVERS_DIR}/${STEAMCMD_UPDATE_SCRIPT}" +map crossfire "${START_ARGS}"
