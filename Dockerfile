FROM steamcmd/steamcmd:alpine
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
