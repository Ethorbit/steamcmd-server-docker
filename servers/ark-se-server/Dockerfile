FROM steamcmd-server
USER root
ENV APP_ID=376030
ENV SERVER_DIR="${SERVERS_DIR}/ARK Survival Evolved Dedicated Server"
ENV START_ARGS="TheIsland?listen?SessionName=My-ARK-Server?ServerCrosshair=True?MapPlayerLocation=True?AllowThirdPersonPlayer=True"
COPY ./start.sh "${IMAGE_DIR}/${START_SCRIPT}"
RUN chown ${USER}:${USER} "${IMAGE_DIR}/${START_SCRIPT}" &&\
    chmod +x "${IMAGE_DIR}/${START_SCRIPT}"
USER ${USER}
