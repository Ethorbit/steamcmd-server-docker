#!/bin/bash
cd "${SERVER_DIR}/ShooterGame/Binaries/Linux/"
./ShooterGameServer "${START_ARGS} -server -log -UseBattlEye"
