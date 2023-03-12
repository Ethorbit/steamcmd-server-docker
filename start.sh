#!/bin/bash
umask "$UMASK"

if [[ ! -f "$STEAMCMD_UPDATE_SCRIPT" ]]; then
	if [[ -z "$APP_ID" ]]; then
		echo "Can't install! No App ID specified!"
		exit
	fi

    printf '@NoPromptForPassword 1\nforce_install_dir "%s"\nlogin anonymous\napp_update %i validate\nquit' \
    "$SERVER_DIR" "$APP_ID" >> "$STEAMCMD_UPDATE_SCRIPT"
    chmod +x "$STEAMCMD_UPDATE_SCRIPT"
fi

if [[ ! -f "$UPDATE_SCRIPT" ]]; then 
    printf '#!/bin/bash\n"%s" +runscript "%s"' \
        "$STEAMCMD_DIR/steamcmd.sh" "$STEAMCMD_UPDATE_SCRIPT" >> "$UPDATE_SCRIPT"
    chmod +x "$UPDATE_SCRIPT"
fi

if [[ ! -f "$START_SCRIPT" ]]; then
	printf '#!/bin/bash\n# Your server start command here' >> "$START_SCRIPT"
    chmod +x "$START_SCRIPT"
fi

function start_server {
    echo "Starting server..."
	"$START_SCRIPT"
}

function install_server {
	echo "Installing server..."
    "$UPDATE_SCRIPT"
}

cd "$SERVER_DIR/" 

if [[ `ls "$SERVER_DIR" --ignore $(basename "${STEAMCMD_UPDATE_SCRIPT}") \
    --ignore $(basename "${UPDATE_SCRIPT}") \
    --ignore $(basename "${START_SCRIPT}") | wc -l` -eq 0 ]]; then
	install_server
fi

start_server
