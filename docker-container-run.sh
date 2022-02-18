#!/bin/sh
DIR="/home/srcds"

if [ ! -f "$DIR/server/update.sh" ]; then
	echo "#!/bin/sh" >> $DIR/server/update.sh
	echo "steamcmd +force_install_dir \"$DIR/server\" +login anonymous +app_update $SRCDS_APPID validate +exit" >> "$DIR/server/update.sh"
	chmod +x "$DIR/server/update.sh"
fi

if [ ! -f "$DIR/server/start.sh" ]; then
	echo "#!/bin/sh" >> "$DIR/server/start.sh"
	echo "\"$DIR/server/srcds_run\" $SRCDS_RUN_ARGS" >> "$DIR/server/start.sh"
	chmod +x "$DIR/server/start.sh"
fi

#if [[ $SRCDS_AUTOUPDATE -ne 0 ]]; then
	echo "Starting server... (Checking updates/missing files in background)"
	"$DIR/server/update.sh" & "$DIR/server/start.sh"
#else
#	if [[ $SRCDS_UPDATE -eq 1 ]]; then
#		echo "Checking for updates or missing files..."
#		"$DIR/server/update.sh"
#		echo "Starting server..."
#		"$DIR/server/start.sh"
#	fi
#fi
