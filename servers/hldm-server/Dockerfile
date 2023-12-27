FROM steamcmd-server
USER root
ENV APP_ID=90
ENV SERVER_DIR="${SERVERS_DIR}/Half-Life"
COPY ./start.sh "${IMAGE_DIR}/${START_SCRIPT}"
COPY ./steam_update_append.txt "${IMAGE_DIR}/${STEAMCMD_APPEND_SCRIPT}"
RUN chown ${USER}:${USER} "${IMAGE_DIR}/${START_SCRIPT}" &&\
    chmod +x "${IMAGE_DIR}/${START_SCRIPT}"
USER ${USER}
