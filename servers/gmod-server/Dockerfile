FROM steamcmd-server
USER root
ENV APPID=4020
COPY ./start.sh "${STARTSCRIPT}"
RUN chown ${USER}:${USER} "${STARTSCRIPT}" &&\
    chmod +x "${STARTSCRIPT}"
VOLUME "${SERVERDIR}"
USER ${USER}
