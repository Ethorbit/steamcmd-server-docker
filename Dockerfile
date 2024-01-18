FROM cm2network/steamcmd
LABEL maintainer="Ethorbit"

USER root
ARG PUID=1000
ARG PGID=1000

# Some games will require a login which can only be done interactively thanks to things like 2FA codes.
# If a username is needed, you will need to start the image interactively the first time to login for the install.
ENV STEAMCMD_LOGIN_USERNAME="anonymous"

# Umask for files created by steamcmd during server installs
# It will NOT cover files that are created by server executables!
ENV UMASK=027
ENV HOME_DIR=${HOMEDIR}
ENV STEAMCMD_DIR=${STEAMCMDDIR}
ENV SERVERS_DIR="${HOMEDIR}/Steam/steamapps/common"
# IMAGE_DIR are files that are moved into SERVERS_DIR at runtime
# The purpose of it is for baking custom start/update scripts into your 
# images and having them still appear in the server/ volume.
ENV IMAGE_DIR="/image"
# For referencing inside server scripts in conjunction with IMAGE_DIR / SERVERS_DIR. 
# This just allows us to give them different names in the future.
ENV STEAMCMD_UPDATE_SCRIPT="steam_update.txt"
ENV STEAMCMD_APPEND_SCRIPT="steam_update_append.txt"
ENV UPDATE_SCRIPT="update.sh"
ENV START_SCRIPT="start.sh"
# You need to integrate these in your server images
ENV APP_ID=
ENV SERVER_DIR=
# Allows servers of the same game to have a 'shared' directory
# Simply bind mount a directory with the same game folder structure to container's /shared 
# Any files in /shared that don't exist in server will get copied over as a symlink
# Symlinks will be auto deleted if they point to shared files that no longer exist
ENV SHARED_DIR=/shared
ENV START_ARGS=
COPY /start.sh /start.sh
RUN usermod -u ${PUID} ${USER} &&\
    groupmod -g ${PGID} ${USER} &&\
    chown ${USER}:${USER} /start.sh &&\
    chmod +x /start.sh &&\
    mkdir "${IMAGE_DIR}" &&\
    mkdir -p "${SERVERS_DIR}" &&\
    chown -R ${USER}:${USER} "${HOME_DIR}/" &&\
    chown ${USER}:${USER} "${IMAGE_DIR}"
WORKDIR "${SERVERS_DIR}"
VOLUME "${SERVERS_DIR}"
VOLUME /server
USER ${USER}
CMD ["/start.sh"]
