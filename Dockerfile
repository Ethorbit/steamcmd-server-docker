FROM ubuntu:jammy
ARG PUID=1000
ARG PGID=1000
ARG MIRROR="http://archive.ubuntu.com/"
ARG TZ="Etc/UTC"
ENV TZ=${TZ}
ENV UMASK="0027"
ENV PATH="$PATH:/usr/games"
ENV SRCDS_RUN_BINARY="srcds_run"
ENV SRCDS_RUN_ARGS=""
COPY ./entrypoint.sh /entrypoint.sh
WORKDIR /home/srcds/
RUN export DEBIAN_FRONTEND=noninteractive &&\
    sed -i "s]htt\(p\|ps\)://archive.ubuntu.com/]$MIRROR]g" /etc/apt/sources.list &&\
    apt-get update -y &&\
    \
    echo "###### Timezone ######" &&\
    apt-get install -y tzdata &&\    
    ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime &&\
    echo $TZ > /etc/timezone &&\
    dpkg-reconfigure tzdata &&\
    \
    echo "###### Steamcmd ######" &&\
    apt-get install -y software-properties-common apt-utils &&\
    dpkg --add-architecture i386 &&\
    apt-get update -y &&\
    echo steam steam/question select "I AGREE" | debconf-set-selections &&\
    apt-get install --no-install-recommends --no-install-suggests -y \
                wget dialog lib32gcc-s1 steamcmd=0~20180105-4 libtinfo5:i386 \
                libncurses5:i386 libcurl3-gnutls:i386 \
                libsdl2-2.0-0:i386 &&\
    \
    echo "###### Steamcmd fix, because Valve tries to symlink files to a nonexistent" &&\
    echo "directory, which obviously fails #######" &&\
    sed -i '\|ln -s "$STEAMROOT" ~/.steam/root|i\\tmkdir ~/.steam' /usr/games/steamcmd &&\ 
    apt-get clean &&\
    \
    echo "###### Srcds user ######" &&\ 
    groupadd -g "$PGID" srcds &&\
    useradd -m -u "$PUID" -g "$PGID" srcds &&\
    mkdir ./server &&\  
    chown srcds:srcds -R ./ &&\ 
    chmod +x /entrypoint.sh
USER srcds
ENTRYPOINT ["/entrypoint.sh"]
