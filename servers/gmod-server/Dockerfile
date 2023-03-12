FROM steamcmd-server
USER root
ENV APP_ID=4020
COPY ./start.sh "${START_SCRIPT}"
RUN chown ${USER}:${USER} "${START_SCRIPT}" &&\
    chmod +x "${START_SCRIPT}" &&\
    dpkg --add-architecture i386 &&\
    apt update &&\
    apt-get install -y --no-install-suggests --no-install-recommends \
        libtinfo5:i386 \
        libncurses5:i386 &&\
    apt-get remove --purge --auto-remove -y &&\
	rm -rf /var/lib/apt/lists/*
VOLUME "${SERVER_DIR}"
USER ${USER}
