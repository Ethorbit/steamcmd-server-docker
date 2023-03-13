FROM steamcmd-server
USER root
ENV APP_ID=276060
COPY ./start.sh "${IMAGE_DIR}/${START_SCRIPT}"
RUN chown ${USER}:${USER} "${IMAGE_DIR}/${START_SCRIPT}" &&\
    chmod +x "${IMAGE_DIR}/${START_SCRIPT}" &&\
    export DEBIAN_FRONTEND=noninteractive &&\
    dpkg --add-architecture i386 &&\
    apt update &&\
    apt-get install -y --no-install-recommends --no-install-suggests \
        wget \
        libssl-dev libssl-dev:i386 \
        zlib1g:i386 &&\
    apt-get remove --purge --auto-remove -y &&\
	rm -rf /var/lib/apt/lists/*
VOLUME "${SERVER_DIR}"
USER ${USER}
