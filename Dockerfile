FROM cm2network/steamcmd
USER root
ARG PUID=1000
ARG PGID=1000
ENV UMASK=027
ENV HOME_DIR=${HOMEDIR}
ENV STEAMCMD_DIR=${STEAMCMDDIR}
ENV SERVER_DIR="${HOMEDIR}/server"
ENV STEAMCMD_UPDATE_SCRIPT="${SERVER_DIR}/steam_update.txt"
ENV UPDATE_SCRIPT="${SERVER_DIR}/update.sh"
ENV START_SCRIPT="${SERVER_DIR}/start.sh"
ENV APP_ID=
ENV START_ARGS=
COPY /start.sh /start.sh
RUN usermod -u ${PUID} ${USER} &&\
    groupmod -g ${PGID} ${USER} &&\
    chown ${USER}:${USER} /start.sh &&\
    chmod +x /start.sh &&\
    mkdir "${SERVER_DIR}" &&\
    chown ${USER}:${USER} "${SERVER_DIR}"
WORKDIR "${SERVER_DIR}"
USER ${USER}
CMD ["/start.sh"]
