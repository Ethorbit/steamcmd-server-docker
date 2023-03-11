FROM ethorbit/steamcmd-server
USER root
ENV APPID=4020
ENV RUNARGS=
ENV STARTCOMMAND="${SERVERDIR}/srcds_run -autoupdate -steam_dir \"${STEAMCMDDIR}\" -steamcmd_script ${SERVERDIR}/update.sh ${RUNARGS}"
USER ${USER}
