#!/bin/sh
DIR="/home/srcds"

if [ ! -f "$DIR/server/update.sh" ]; then
	if [ -z $SRCDS_APPID ]; then
		echo "Can't install! No App ID specified!"
		exit
	fi

	echo "#!/bin/sh" >> $DIR/server/update.sh
	echo "steamcmd +force_install_dir \"$DIR/server\" +login anonymous +app_update $SRCDS_APPID validate +exit" >> "$DIR/server/update.sh"
	chmod +x "$DIR/server/update.sh"
fi

#if [ ! -f "$DIR/server/start.sh" ]; then
	echo "" > "$DIR/server/start.sh"
	echo "#!/bin/sh" >> "$DIR/server/start.sh"
	echo "\"$DIR/server/srcds_run\" $SRCDS_RUN_ARGS" >> "$DIR/server/start.sh"
	chmod +x "$DIR/server/start.sh"
#fi

if [ -z $SRCDS_AUTOUPDATE ]; then
	SRCDS_AUTOUPDATE=1
fi

if [ -z $SRCDS_UPDATE ]; then # Manual update is off by default (duh)
	SRCDS_UPDATE=0
fi

if [ "$SRCDS_AUTOUPDATE" != "0" ]; then
	echo "Starting server... (Checking for updates and validating files in the background)"
	"$DIR/server/start.sh" & nohup "$DIR/server/update.sh" > /dev/null
else
	if [ "$SRCDS_UPDATE" = "1" ]; then
		echo "Checking for updates and validating files..."
		"$DIR/server/update.sh"
		echo "Starting server..."
		"$DIR/server/start.sh"
	fi
fi
