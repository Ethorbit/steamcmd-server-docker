FROM steamcmd/steamcmd:alpine
ENV SRCDS_APPID="4020"
ENV SRCDS_RUN_ARGS='-tickrate 66 +rcon_password "password" +gamemode "sandbox" +map "gm_construct"'
WORKDIR /home/srcds/
RUN apk update &&\
    apk add runuser shadow libgcc &&\
    addgroup srcds &&\
    adduser -DG srcds srcds &&\
    mkdir ./server ./steamcmd &&\
    wget "https://raw.githubusercontent.com/Ethorbit/Docker-Srcds/main/docker-container-entry.sh" &&\
    wget "https://raw.githubusercontent.com/Ethorbit/Docker-Srcds/main/docker-container-run.sh" &&\
    chmod +x ./docker-container-entry.sh &&\
    chmod +x ./docker-container-run.sh
ENTRYPOINT ["/bin/sh", "/home/srcds/docker-container-entry.sh"]
CMD ["/bin/sh", "./docker-container-run.sh"]
