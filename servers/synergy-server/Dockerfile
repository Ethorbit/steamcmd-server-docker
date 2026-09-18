FROM steamcmd-server
USER root
ENV APP_ID=17520
ENV SERVER_DIR="${SERVERS_DIR}/Synergy"
COPY ./start.sh "${IMAGE_DIR}/${START_SCRIPT}"
COPY ./steam_update_append.txt "${IMAGE_DIR}/${STEAMCMD_APPEND_SCRIPT}"
RUN chown ${USER}:${USER} "${IMAGE_DIR}/${START_SCRIPT}" &&\
    chmod +x "${IMAGE_DIR}/${START_SCRIPT}" &&\
    dpkg --add-architecture i386 &&\
    apt update &&\
    apt-get install -y --no-install-suggests --no-install-recommends libtinfo6:i386 libsdl2-2.0-0:i386 libcurl4t64:i386 libatomic1:i386 &&\
    ln -s /usr/lib/i386-linux-gnu/libtinfo.so.6 /usr/lib/i386-linux-gnu/libtinfo.so.5 &&\
    apt-get remove --purge --auto-remove -y &&\
	rm -rf /var/lib/apt/lists/*
USER ${USER}
