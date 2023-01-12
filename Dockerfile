FROM ubuntu:jammy
WORKDIR /home/srcds/
ENV PATH="$PATH:/usr/games"
ENV SRCDS_RUN_BINARY="srcds_run"
ENV SRCDS_RUN_ARGS=""
COPY ./docker-container-run.sh /docker-container-run.sh
RUN apt-get update -y &&\
    export DEBIAN_FRONTEND=noninteractive &&\
    apt-get install -y software-properties-common apt-utils &&\
    dpkg --add-architecture i386 &&\
    apt-get update -y &&\
    echo steam steam/question select "I AGREE" | debconf-set-selections &&\
    apt-get install --no-install-recommends --no-install-suggests -y \
                wget dialog lib32gcc-s1 steamcmd libtinfo5:i386 \
                libncurses5:i386 libcurl3-gnutls:i386 \
                libsdl2-2.0-0:i386 &&\ 
    # Dumb steamcmd fix, because Valve doesn't know how to properly shell script :/ 
    # (they try to symlink files into a nonexistent directory on purpose, which obviously fails)
    sed -i '\|ln -s "$STEAMROOT" ~/.steam/root|i\\tmkdir ~/.steam' /usr/games/steamcmd &&\
    useradd srcds &&\
    mkdir ./server &&\
    chown srcds:srcds -R ./ &&\
    chmod +x /docker-container-run.sh
USER srcds
CMD ["/bin/bash", "/docker-container-run.sh"]
