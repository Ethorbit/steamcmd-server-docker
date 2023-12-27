#!/bin/bash
"${SERVER_DIR}/srcds_run" -autoupdate -steam_dir "${STEAMCMD_DIR}" -steamcmd_script "${SERVERS_DIR}/${STEAMCMD_UPDATE_SCRIPT}" "${START_ARGS}"

