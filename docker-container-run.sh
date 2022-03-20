#!/bin/bash
DIR="/home/srcds"
UPDATE_SCRIPT_NAME="update.sh"
UPDATE_SCRIPT="$DIR/server/$UPDATE_SCRIPT_NAME"
AUTO_UPDATE_SCRIPT_NAME="auto-update.sh"
AUTO_UPDATE_SCRIPT="$DIR/server/$AUTO_UPDATE_SCRIPT_NAME"
SRCDS_UPDATE_INTERVAL=43200 # Interval (in seconds)
INSTALL_SCRIPT="$UPDATE_SCRIPT"
START_SCRIPT_NAME="start.sh"
START_SCRIPT="$DIR/server/$START_SCRIPT_NAME"
#AUTO_RESTART_SCRIPT_NAME="srcds-auto-restart.sh"
#AUTO_RESTART_SCRIPT="$DIR/$AUTO_RESTART_SCRIPT_NAME"

if [[ ! $SRCDS_UPDATE_INTERVAL =~ ^-?[0-9]+$ ]]; then
	SRCDS_UPDATE_INTERVAL=43200
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

if [ ! -f "$AUTO_UPDATE_SCRIPT" ]; then
	echo "#!/bin/sh" >> "$AUTO_UPDATE_SCRIPT"
	echo "while true; do" >> "$AUTO_UPDATE_SCRIPT"
	echo "nohup \"$UPDATE_SCRIPT\" > /dev/null 2>&1" >> "$AUTO_UPDATE_SCRIPT"
	echo "sleep $SRCDS_UPDATE_INTERVAL" >> "$AUTO_UPDATE_SCRIPT"
	echo "done &" >> "$AUTO_UPDATE_SCRIPT"
	chmod +x "$AUTO_UPDATE_SCRIPT"
fi

if [ ! -f "$START_SCRIPT" ]; then
	rm "$DIR/server/start.sh"
	echo "#!/bin/sh" >> "$START_SCRIPT"
	echo "\"$DIR/server/srcds_run\" $SRCDS_RUN_ARGS" >> "$START_SCRIPT"
	chmod +x "$START_SCRIPT"
fi

# No need for auto restart, SRCDS Linux does it already.
# if [ ! -f "$AUTO_RESTART_SCRIPT" ]; then
# 	# if $(pgrep -c srcds_linux = 0); then
		# start start.sh again
	# fi
# fi

if [ -z "$SRCDS_AUTOUPDATE" ]; then
	SRCDS_AUTOUPDATE=1
fi

if [ -z "$SRCDS_UPDATE" ]; then # Manual update is off by default (duh)
	SRCDS_UPDATE=0
fi

function start_server {
	echo "Starting server..."
	"$START_SCRIPT"
}

function install_server {
	echo "Installing server..."
	"$INSTALL_SCRIPT"
}

function start_server_while_updating {
	echo "Starting server... (Checking for updates and validating files in the background)"
	"$AUTO_UPDATE_SCRIPT"
	"$START_SCRIPT"
}

function update_and_start_server {
	echo "Checking for updates and validating files..."
	"$UPDATE_SCRIPT"
	start_server
}

# Prevent overlapping
pkill "$AUTO_UPDATE_SCRIPT_NAME"
pkill "$UPDATE_SCRIPT_NAME"
pkill "$START_SCRIPT_NAME"
pkill "srcds_run"

if [ ! -f "$DIR/server/srcds_run" ]; then
	install_server
fi

if [ "$SRCDS_AUTOUPDATE" != "0" ]; then
	start_server_while_updating
else
	if [ "$SRCDS_UPDATE" = "1" ]; then
		update_and_start_server
	fi
fi
