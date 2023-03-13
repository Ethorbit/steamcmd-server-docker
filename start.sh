#!/bin/bash
umask "$UMASK"

# Copy all files/dirs baked inside the server image into the server volume
# If the file/dir already exists, it won't make its way to the volume.
find "$IMAGE_DIR/" -mindepth 1 -maxdepth 1 -exec /bin/bash -c "cp -nar {} '$SERVER_DIR/'" \;

# Create defaults for scripts that are not baked into the server image
if [[ ! -f "$SERVER_DIR/$STEAMCMD_UPDATE_SCRIPT" ]]; then
	if [[ -z "$APP_ID" ]]; then
		echo "Can't install! No App ID specified!"
		exit
	fi

    printf '@NoPromptForPassword 1\nforce_install_dir "%s"\nlogin anonymous\napp_update %i validate\nquit' \
    "$SERVER_DIR" "$APP_ID" >> "$SERVER_DIR/$STEAMCMD_UPDATE_SCRIPT"
    chmod +x "$SERVER_DIR/$STEAMCMD_UPDATE_SCRIPT"
fi

if [[ ! -f "$SERVER_DIR/$UPDATE_SCRIPT" ]]; then 
    printf '#!/bin/bash\n"%s" +runscript "%s"' \
        "$STEAMCMD_DIR/steamcmd.sh" "$SERVER_DIR/$STEAMCMD_UPDATE_SCRIPT" >> "$SERVER_DIR/$UPDATE_SCRIPT"
    chmod +x "$SERVER_DIR/$UPDATE_SCRIPT"
fi

if [[ ! -f "$SERVER_DIR/$START_SCRIPT" ]]; then
	printf '#!/bin/bash\n# Your server start command here' >> "$SERVER_DIR/$START_SCRIPT"
    chmod +x "$SERVER_DIR/$START_SCRIPT"
fi

function start_server {
    echo "Starting server..."
	"$SERVER_DIR/$START_SCRIPT"
}

function install_server {
	echo "Installing server..."
    "$SERVER_DIR/$UPDATE_SCRIPT"
}

cd "$SERVER_DIR/" 

# There's probably a MUCH better way to check if a server installed successfully.
# Feel free to improve this.
if [[ ! -f "${SERVER_DIR}/.server_installed_successfully" ]]; then
    install_server

    if [[ $? -eq 0 ]]; then 
        touch "${SERVER_DIR}/.server_installed_successfully"
    else
        echo "Server failed to install ($?)"
        exit $?
    fi 
fi

start_server
