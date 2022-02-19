#!/bin/sh
DIR="/home/srcds"
UPDATE_SCRIPT="$DIR/server/update.sh"
INSTALL_SCRIPT=$UPDATE_SCRIPT
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

start_server()
{
	echo "Starting server..."
	"$START_SCRIPT"
}

if [ ! -f "$DIR/server/srcds_run" ]; then
	echo "Installing server..."
	"$INSTALL_SCRIPT"
	start_server
else
	if [ "$SRCDS_AUTOUPDATE" != "0" ]; then
		echo "Starting server... (Checking for updates and validating files in the background)"
		"$START_SCRIPT" & nohup "$UPDATE_SCRIPT" > /dev/null
	else
		if [ "$SRCDS_UPDATE" = "1" ]; then
			echo "Checking for updates and validating files..."
			"$UPDATE_SCRIPT"
			start_server
		fi
	fi
fi
