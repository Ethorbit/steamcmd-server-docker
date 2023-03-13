#!/bin/bash 
"${SERVER_DIR}/srcds_run" -autoupdate -steam_dir "${STEAMCMD_DIR}" -steamcmd_script "${SERVER_DIR}/${STEAMCMD_UPDATE_SCRIPT}" "${START_ARGS}"

