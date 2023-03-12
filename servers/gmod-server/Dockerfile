FROM steamcmd-server
USER root
ENV APPID=4020
COPY ./start.sh "${STARTSCRIPT}"
RUN chown ${USER}:${USER} "${STARTSCRIPT}" &&\
    chmod +x "${STARTSCRIPT}" &&\
    dpkg --add-architecture i386 &&\
    apt update &&\
    apt-get install -y --no-install-suggests --no-install-recommends \
        libtinfo5:i386 \
        libncurses5:i386 &&\
    apt-get remove --purge --auto-remove -y &&\
	rm -rf /var/lib/apt/lists/*
VOLUME "${SERVERDIR}"
USER ${USER}
