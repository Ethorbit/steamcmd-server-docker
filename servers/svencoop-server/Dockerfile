FROM steamcmd-server
USER root
ENV APPID=276060
COPY ./start.sh "${STARTSCRIPT}"
RUN chown ${USER}:${USER} "${STARTSCRIPT}" &&\
    chmod +x "${STARTSCRIPT}" &&\
    export DEBIAN_FRONTEND=noninteractive &&\
    dpkg --add-architecture i386 &&\
    apt update &&\
    apt-get install -y --no-install-recommends --no-install-suggests \
        wget \
        libssl-dev libssl-dev:i386 \
        zlib1g:i386 &&\
    apt-get remove --purge --auto-remove -y &&\
	rm -rf /var/lib/apt/lists/*
VOLUME "${SERVERDIR}"
USER ${USER}
