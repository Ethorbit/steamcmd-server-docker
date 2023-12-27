#!/bin/bash
"${SERVER_DIR}/srcds_run" -game synergy -autoupdate -steam_dir "${STEAMCMD_DIR}" -steamcmd_script "${SERVERS_DIR}/${STEAMCMD_UPDATE_SCRIPT}" +map d1_trainstation_01 "${START_ARGS}"
