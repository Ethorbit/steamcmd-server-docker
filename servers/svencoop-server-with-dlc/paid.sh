#!/bin/bash

if [ ! -f "${SERVERS_DIR}/.server_installed_dlc_successfully.txt" ]; then
    echo "Installing DLC..."
    cd "${SERVER_DIR}/svencoop"

    install_opposing_force()
    {
        echo "Installing Opposing Force.."
        ./Install_OpFor_Support.sh
    }

    install_blueshift()
    {
        echo "Installing Blue Shift.."
        ./Install_bshift_Support.sh
    }

    install_opposing_force
    install_blueshift
    touch "${SERVERS_DIR}/.server_installed_dlc_successfully.txt"
    cd "${SERVER_DIR}"
fi
