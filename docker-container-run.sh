#!/bin/bash
DIR="/home/srcds"
UPDATE_SCRIPT="$DIR/server/update.sh"
INSTALL_SCRIPT="$UPDATE_SCRIPT"
START_SCRIPT="$DIR/server/start.sh"

if [ ! -f "$DIR/server/update.sh" ]; then
	if [ -z "$SRCDS_APPID" ]; then
		echo "Can't install! No App ID specified!"
		exit
	fi

	echo "#!/bin/sh" >> "$DIR/server/update.sh"
	echo "steamcmd +force_install_dir \"$DIR/server\" +login anonymous +app_update $SRCDS_APPID validate +exit" >> "$DIR/server/update.sh"
	chmod +x "$DIR/server/update.sh"
fi

if [ ! -z "$SRCDS_RUN_ARGS" ]; then
	rm "$DIR/server/start.sh"
	echo "#!/bin/sh" >> "$DIR/server/start.sh"
	echo "\"$DIR/server/srcds_run\" $SRCDS_RUN_ARGS" >> "$DIR/server/start.sh"
	chmod +x "$DIR/server/start.sh"
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
	start_server
	#echo "Starting server... (Checking for updates and validating files in the background)"
	#"$START_SCRIPT" & nohup "$UPDATE_SCRIPT" > /dev/null
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
