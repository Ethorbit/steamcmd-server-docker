FROM steamcmd-server
USER root
ENV APP_ID=276060
ENV SERVER_DIR="${SERVERS_DIR}/Sven Co-op Dedicated Server"
ENV PAID_SCRIPT="paid.sh"
COPY ./paid.sh "${IMAGE_DIR}/${PAID_SCRIPT}"
COPY ./start.sh "${IMAGE_DIR}/${START_SCRIPT}"
COPY ./steam_update_append.txt "${IMAGE_DIR}/${STEAMCMD_APPEND_SCRIPT}"
RUN chown ${USER}:${USER} "${IMAGE_DIR}/${START_SCRIPT}" &&\
    chmod +x "${IMAGE_DIR}/${START_SCRIPT}" &&\
    chmod +x "${IMAGE_DIR}/${PAID_SCRIPT}" &&\
    export DEBIAN_FRONTEND=noninteractive &&\
    dpkg --add-architecture i386 &&\
    apt update &&\
    apt-get install -y --no-install-recommends --no-install-suggests \
        wget \
        libssl-dev libssl-dev:i386 \
        zlib1g:i386 \
        unzip &&\
    apt-get remove --purge --auto-remove -y &&\
	rm -rf /var/lib/apt/lists/*
USER ${USER}
