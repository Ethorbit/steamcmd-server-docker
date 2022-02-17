FROM alpine:latest
ARG USER_ID
ARG GROUP_ID
ARG SRCDS_APPID="4020"
ARG SRCDS_RUN_ARGS='-tickrate 66 +rcon_password "password" +gamemode "sandbox" +map "gm_construct"'
WORKDIR /home/srcds/
RUN if [[ -z "$USER_ID" || -z "$GROUP_ID" ]]; then echo "WARNING: You did not assign a USER_ID or GROUP_ID! Rebuild image with a --build-arg USER_ID=# and --build-arg GROUP_ID=#"; fi &&\
    apk update &&\
    apk add runuser &&\
    addgroup -g $GROUP_ID srcds &&\
    adduser -DG srcds -u $USER_ID srcds &&\
    mkdir ./server ./steamcmd &&\
    wget "https://raw.githubusercontent.com/Ethorbit/Docker-Srcds/main/docker-container-entry.sh" &&\
    wget "https://raw.githubusercontent.com/Ethorbit/Docker-Srcds/main/docker-container-run.sh" &&\
    chmod +x ./docker-container-entry.sh &&\
    chmod +x ./docker-container-run.sh
ENTRYPOINT ["/bin/sh", "/home/srcds/docker-container-entry.sh"]
CMD ["/bin/sh", "./docker-container-run.sh"]
