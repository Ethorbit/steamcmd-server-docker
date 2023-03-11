FROM ethorbit/steamcmd-server
USER root
ENV APPID=276060
ENV RUNARGS=
ENV STARTCOMMAND="${SERVERDIR}/svends_run -autoupdate -steam_dir \"${STEAMCMDDIR}\" -steamcmd_script ${SERVERDIR}/update.sh ${RUNARGS}"
RUN export DEBIAN_FRONTEND=noninteractive &&\
    dpkg --add-architecture i386 &&\
    apt update &&\
    apt-get install -y wget libssl-dev libssl-dev:i386 
    #cd /root &&\
    #wget -qO libssl.deb http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_i386.deb &&\
    #dpkg -i ./libssl.deb 
USER ${USER}
