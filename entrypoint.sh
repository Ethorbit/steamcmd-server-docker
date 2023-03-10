#!/bin/bash
MODE= && for n in $(echo "$UMASK" | fold -w1); do n=$((7 - $n)) MODE="$MODE$n"; done
umask "$UMASK"

DIR="/home/srcds"
UPDATE_SCRIPT_NAME="update.sh"
UPDATE_SCRIPT="$DIR/server/$UPDATE_SCRIPT_NAME"
AUTO_VALIDATE_SCRIPT_NAME="auto-validate.sh"
AUTO_VALIDATE_SCRIPT="$DIR/server/$AUTO_VALIDATE_SCRIPT_NAME"
SRCDS_VALIDATE_INTERVAL=43200 # Interval (in seconds)
INSTALL_SCRIPT="$UPDATE_SCRIPT"
START_SCRIPT_NAME="start.sh"
START_SCRIPT="$DIR/server/$START_SCRIPT_NAME"

if [[ ! $AUTO_VALIDATE_INTERVAL =~ ^-?[0-9]+$ ]]; then
	AUTO_VALIDATE_INTERVAL=43200
fi

if [ ! -f "$UPDATE_SCRIPT" ]; then
	if [ -z "$SRCDS_APPID" ]; then
		echo "Can't install! No App ID specified!"
		exit
	fi

	echo "#!/bin/sh" >> "$UPDATE_SCRIPT"
    echo "steamcmd +force_install_dir \"$DIR/server\" +login anonymous +app_update $SRCDS_APPID validate +exit" >> "$DIR/server/update.sh"
	chmod +x "$UPDATE_SCRIPT"
fi

if [ ! -f "$AUTO_VALIDATE_SCRIPT" ]; then
	echo "#!/bin/sh" >> "$AUTO_VALIDATE_SCRIPT"
    echo "while true; do" >> "$AUTO_VALIDATE_SCRIPT"
	echo "nohup \"$UPDATE_SCRIPT\" > /dev/null 2>&1" >> "$AUTO_VALIDATE_SCRIPT"
	echo "sleep $SRCDS_VALIDATE_INTERVAL" >> "$AUTO_VALIDATE_SCRIPT"
	echo "done &" >> "$AUTO_VALIDATE_SCRIPT"
	chmod +x "$AUTO_VALIDATE_SCRIPT"
fi

if [ ! -f "$START_SCRIPT" ]; then
	rm "$DIR/server/start.sh"
	echo "#!/bin/sh" >> "$START_SCRIPT"
    echo "\"$DIR/server/$SRCDS_RUN_BINARY\" -autoupdate -steam_dir /home/srcds/.steam/steamcmd -steamcmd_script /home/srcds/server/update.sh $SRCDS_RUN_ARGS" >> "$START_SCRIPT"
	chmod +x "$START_SCRIPT"
fi

if [ -z "$SRCDS_VALIDATE" ]; then # Manual update is off by default (duh)
	SRCDS_VALIDATE=0
fi

if [ -z "$SRCDS_AUTOVALIDATE" ]; then
	SRCDS_AUTOVALIDATE=0
fi

function start_server {
    echo "Starting server..."
    
    if [[ "$SRCDS_RECURSIVE_FILE_PERMISSIONS" -gt 0 ]]; then
        chmod -R "$MODE" "$DIR/server/"
    fi
    
	"$START_SCRIPT"
}

function install_server {
	echo "Installing server..."
    "$INSTALL_SCRIPT"
}

function start_server_while_updating {
	echo "Starting server... (Validating files in the background)"
	"$AUTO_VALIDATE_SCRIPT"
	"$START_SCRIPT"
}

function update_and_start_server {
	echo "Checking for updates and validating files..."
	"$UPDATE_SCRIPT"
	start_server
}

# Prevent overlapping
pkill "$AUTO_VALIDATE_SCRIPT_NAME"
pkill "$UPDATE_SCRIPT_NAME"
pkill "$START_SCRIPT_NAME"

cd "$DIR/server/" 

if [ ! -f "$DIR/server/$SRCDS_RUN_BINARY" ]; then
	install_server
fi

if [ "$SRCDS_AUTOVALIDATE" != "0" ]; then
	start_server_while_updating
else
	if [ "$SRCDS_VALIDATE" = "1" ]; then
		update_and_start_server
	else
		start_server
	fi
fi
