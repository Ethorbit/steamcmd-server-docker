#!/bin/sh

# This file runs when the docker container starts;
# however, this was made on image creation;
# we need to create the runtime srcds script
# (if it doesn't exist) and then always run it:
DIR=$(dirname -- $0)

if [ ! -f "$DIR/server/srcds_start.sh" ]; then
	echo -e "#!/bin/sh\n" >> $DIR/server/srcds_start.sh
	echo "\"$DIR/server/srcds_run\" $SRCDS_RUN_ARGS" >> $DIR/server/srcds_start.sh
	chmod +x "$DIR/server/srcds_start.sh"
fi

exec $DIR/server/srcds_start.sh
