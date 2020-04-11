#! /bin/bash

cd $STEAMCMD_DIR
echo "Installing Counter Strike 1.6 Dedicated server"
# install hlds and cs server, needs to be done more than once sometimes
./steamcmd.sh +login anonymous +force_install_dir $HLDS_DIR +app_set_config 90 mod cstrike +app_update 90 validate +quit || true
./steamcmd.sh +login anonymous +force_install_dir $HLDS_DIR +app_set_config 90 mod cstrike +app_update 90 validate +quit || true

echo "Installation complete"