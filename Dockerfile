FROM cm2network/steamcmd
USER root
ARG PUID=1000
ARG PGID=1000
ENV UMASK=027
ENV APPID=
ENV SERVERDIR="${HOMEDIR}/server"
ENV UPDATESCRIPT="${SERVERDIR}/update.txt"
ENV STARTSCRIPT="${SERVERDIR}/start.sh"
COPY /start.sh /start.sh
RUN usermod -u ${PUID} ${USER} &&\
    groupmod -g ${PGID} ${USER} &&\
    chown ${USER}:${USER} /start.sh &&\
    chmod +x /start.sh &&\
    mkdir ${SERVERDIR} &&\
    chown ${USER}:${USER} ${SERVERDIR}
WORKDIR ${SERVERDIR}
USER ${USER}
CMD ["/start.sh"]
