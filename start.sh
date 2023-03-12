#!/bin/bash
umask "$UMASK"

if [[ ! -f "$UPDATESCRIPT" ]]; then
	if [[ -z "$APPID" ]]; then
		echo "Can't install! No App ID specified!"
		exit
	fi

    printf '@NoPromptForPassword 1\nforce_install_dir "%s"\nlogin anonymous\napp_update %i validate\nquit' \
        "$SERVERDIR" "$APPID" >> "$UPDATESCRIPT"
    chmod +x "$UPDATESCRIPT"
fi

if [[ ! -f "$STARTSCRIPT" ]]; then
	printf '#!/bin/bash\n# Your server start command here' >> "$STARTSCRIPT"
    chmod +x "$STARTSCRIPT"
fi

function start_server {
    echo "Starting server..."
	"$STARTSCRIPT"
}

function install_server {
	echo "Installing server..."
    "$STEAMCMDDIR/steamcmd.sh" +runscript "$UPDATESCRIPT"
}

cd "$SERVERDIR/" 

if [[ `ls "$SERVERDIR" --ignore $(basename "${UPDATESCRIPT}") \
    --ignore $(basename "${STARTSCRIPT}") | wc -l` -eq 0 ]]; then
	install_server
fi

start_server
