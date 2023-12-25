FROM steamcmd-server
USER root
ENV APP_ID=90
COPY ./start.sh "${IMAGE_DIR}/${START_SCRIPT}"
RUN chown ${USER}:${USER} "${IMAGE_DIR}/${START_SCRIPT}" &&\
    chmod +x "${IMAGE_DIR}/${START_SCRIPT}" &&\
    echo "Like with all Valve products, HLDS is broken! (It will not download all the files.)" &&\
    echo "We will now override the default install script with one that does literally the same thing, except multiple times, to ensure that ALL files are (hopefully) downloaded!" &&\
    printf '@NoPromptForPassword 1\nforce_install_dir "%s"\nlogin anonymous\napp_update %i\napp_update %i validate\napp_update %i validate\nquit' \
    "$SERVER_DIR" "$APP_ID" "$APP_ID" "$APP_ID" >> "$IMAGE_DIR/$STEAMCMD_UPDATE_SCRIPT"
VOLUME "${SERVER_DIR}"
USER ${USER}
