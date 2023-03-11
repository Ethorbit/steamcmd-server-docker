#!/bin/bash
umask "$UMASK"
UPDATE_SCRIPT="$SERVERDIR/update.sh"
START_SCRIPT="$SERVERDIR/start.sh"

if [[ ! -f "$UPDATE_SCRIPT" ]]; then
	if [[ -z "$APPID" ]]; then
		echo "Can't install! No App ID specified!"
		exit
	fi

    echo "#!/bin/sh" >> "$UPDATE_SCRIPT"
    echo "$HOME/steamcmd/steamcmd.sh +force_install_dir \"$SERVERDIR\" +login anonymous +app_update $APPID validate +exit" >> "$UPDATE_SCRIPT"
	chmod +x "$UPDATE_SCRIPT"
fi

if [[ ! -f "$START_SCRIPT" ]]; then
	echo "#!/bin/sh" >> "$START_SCRIPT"
	echo "$STARTCOMMAND" >> "$START_SCRIPT"
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

cd "$SERVERDIR/" 

if [[ `ls "$SERVERDIR" --ignore "update.sh" --ignore "start.sh" | wc -l` -eq 0 ]]; then
	install_server
fi

start_server
