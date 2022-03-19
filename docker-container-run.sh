#!/bin/bash
DIR="/home/srcds"
UPDATE_SCRIPT="$DIR/server/update.sh"
INSTALL_SCRIPT="$UPDATE_SCRIPT"
START_SCRIPT="$DIR/server/start.sh"
UPDATE_INTERVAL=120 #86400 # Interval (in seconds)

if [ ! -f "$UPDATE_SCRIPT" ]; then
	if [ -z "$SRCDS_APPID" ]; then
		echo "Can't install! No App ID specified!"
		exit
	fi

	echo "#!/bin/sh" >> "$UPDATE_SCRIPT"
	echo "steamcmd +force_install_dir \"$DIR/server\" +login anonymous +app_update $SRCDS_APPID validate +exit" >> "$DIR/server/update.sh"
	chmod +x "$UPDATE_SCRIPT"
fi

if [ ! -f "$START_SCRIPT" ]; then
	rm "$DIR/server/start.sh"
	echo "#!/bin/sh" >> "$START_SCRIPT"
	echo "\"$DIR/server/srcds_run\" $SRCDS_RUN_ARGS" >> "$START_SCRIPT"
	chmod +x "$START_SCRIPT"
fi

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
	start_server
}

function start_server_while_updating {
	echo "Starting server... (Checking for updates and validating files in the background)"
	nohup watch -n $UPDATE_INTERVAL "$UPDATE_SCRIPT" > /dev/null &
}

function update_and_start_server {
	echo "Checking for updates and validating files..."
	"$UPDATE_SCRIPT"
	start_server
}

if [ ! -f "$DIR/server/srcds_run" ]; then
	install_server
else
	if [ "$SRCDS_AUTOUPDATE" != "0" ]; then
		start_server_while_updating
	else
		if [ "$SRCDS_UPDATE" = "1" ]; then
			update_and_start_server
		fi
	fi
fi
