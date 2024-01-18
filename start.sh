#!/bin/bash
umask "$UMASK"

# Copy all files/dirs baked inside the server image into the server volume
# If the file/dir already exists, it won't make its way to the volume.
find "$IMAGE_DIR/" -mindepth 1 -maxdepth 1 -exec /bin/bash -c "cp -nar {} '$SERVERS_DIR/'" \;

# Create defaults for scripts that are not baked into the server image
if [ ! -f "$SERVERS_DIR/$STEAMCMD_UPDATE_SCRIPT" ]; then
	if [ -z "$APP_ID" ]; then
		echo "Can't install! No App ID specified!"
		exit
	fi

    if [ -z "$STEAMCMD_LOGIN_USERNAME" ] || [ "$STEAMCMD_LOGIN_USERNAME" = "anonymous" ]; then
        printf '@NoPromptForPassword\nlogin anonymous\n' >> "$SERVERS_DIR/$STEAMCMD_UPDATE_SCRIPT"
    else
        printf 'login %s\n' "$STEAMCMD_LOGIN_USERNAME" >> "$SERVERS_DIR/$STEAMCMD_UPDATE_SCRIPT"
    fi

    if [ ! -f "$STEAMCMD_APPEND_SCRIPT" ]; then
        printf 'app_update %i\napp_update %i validate\nquit' "$APP_ID" "$APP_ID" >> "$SERVERS_DIR/$STEAMCMD_UPDATE_SCRIPT"
    else
        cat "$STEAMCMD_APPEND_SCRIPT" >> "$SERVERS_DIR/$STEAMCMD_UPDATE_SCRIPT"
        rm "$STEAMCMD_APPEND_SCRIPT" # Not needed anymore, users will edit steam_update.txt if they wanna make changes
    fi
    
    chmod +x "$SERVERS_DIR/$STEAMCMD_UPDATE_SCRIPT"
fi

if [ ! -f "$SERVERS_DIR/$UPDATE_SCRIPT" ]; then 
    printf '#!/bin/bash\n"%s" +runscript "%s"' \
        "$STEAMCMD_DIR/steamcmd.sh" "$SERVERS_DIR/$STEAMCMD_UPDATE_SCRIPT" >> "$SERVERS_DIR/$UPDATE_SCRIPT"
    chmod +x "$SERVERS_DIR/$UPDATE_SCRIPT"
fi

if [ ! -f "$SERVERS_DIR/$START_SCRIPT" ]; then
	printf '#!/bin/bash\n# Your server start command here' >> "$SERVERS_DIR/$START_SCRIPT"
    chmod +x "$SERVERS_DIR/$START_SCRIPT"
fi

function start_server {
    cd "$SERVER_DIR/" 
    echo "Starting server..."
	"$SERVERS_DIR/$START_SCRIPT"
}

function install_server {
	echo "Installing server..."
    "$SERVERS_DIR/$UPDATE_SCRIPT"
}

# There's probably a MUCH better way to check if a server installed successfully.
# Feel free to improve this.
if [ ! -f "${SERVERS_DIR}/.server_installed_successfully" ]; then
    install_server

    if [ $? -eq 0 ]; then 
        touch "${SERVERS_DIR}/.server_installed_successfully"
    else
        echo "Server failed to install ($?)"
        exit $?
    fi 
fi

echo "Merging shared files.."
cp --preserve=timestamp -dRns "${SHARED_DIR}/"* "${SERVERS_DIR}/"

start_server
