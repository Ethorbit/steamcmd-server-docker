FROM steamcmd-server
USER root
ENV APP_ID=4020
ENV SERVER_DIR="${SERVERS_DIR}/GarrysModDS"
COPY ./start.sh "${IMAGE_DIR}/${START_SCRIPT}"
RUN chown ${USER}:${USER} "${IMAGE_DIR}/${START_SCRIPT}" &&\
    chmod +x "${IMAGE_DIR}/${START_SCRIPT}" &&\
    dpkg --add-architecture i386 &&\
    apt update &&\
    apt-get install -y --no-install-suggests --no-install-recommends libtinfo6:i386 libncurses6:i386 &&\
    ln -s /usr/lib/i386-linux-gnu/libtinfo.so.6 /usr/lib/i386-linux-gnu/libtinfo.so.5 &&\
    ln -s /usr/lib/i386-linux-gnu/libncurses.so.6 /usr/lib/i386-linux-gnu/libncurses.so.5 &&\
    apt-get remove --purge --auto-remove -y &&\
    rm -rf /var/lib/apt/lists/*
USER ${USER}
