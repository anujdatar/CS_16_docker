#! /bin/bash

# load server constants
source ~/store/constants.sh

load_config() {
  echo "Loading server configs"
  yes | cp -rfa ~/store/cfgs/. ~/hlds/cstrike/
}

store_config() {
  echo "Storing server configs"
  yes | cp -rfa ~/hlds/cstrike/server.cfg ~/store/cfgs/server.cfg
  yes | cp -rfa ~/hlds/cstrike/custom_server.cfg ~/store/cfgs/custom_server.cfg
  yes | cp -rfa ~/hlds/cstrike/listip.cfg ~/store/cfgs/listip.cfg
  yes | cp -rfa ~/hlds/cstrike/banned.cfg ~/store/cfgs/banned.cfg

  yes | cp -rfa ~/hlds/cstrike/addons/podbot/podbot.cfg ~/store/cfgs/addons/podbot/podbot.cfg
}

install() {
  cd $STEAMCMD_DIR
  echo "Installing Counter Strike 1.6 Dedicated server"
  # install hlds and cs server
  ./steamcmd.sh +login anonymous +force_install_dir $HLDS_DIR +app_set_config 90 mod cstrike +app_update 90 validate +quit || true
  ./steamcmd.sh +login anonymous +app_update 70 +quit || true
  ./steamcmd.sh +login anonymous +app_update 10 +quit || true
  ./steamcmd.sh +login anonymous +force_install_dir $HLDS_DIR +app_set_config 90 mod cstrike +app_update 90 validate +quit || true

  # copy mods to server
  install_metamod
  install_amxmodx
  install_podbot

  echo "Installation complete"
}

install_metamod() {
  # check if metamod is installed
  [[ -d $HLDS_DIR/cstrike/addons/metamod ]] && echo "MetaMod already installed" && return
  
  echo "Installing MetaMod on game server"
  mkdir -p $HLDS_DIR/cstrike/addons
  # extract metamod
  tar xzf ~/mods/metamod-1.21.1.tar.gz -C $HLDS_DIR/cstrike/addons/
  # copy liblist.gam to enable metamod on game server
  cp -fa ~/mods/liblist.gam $HLDS_DIR/cstrike/liblist.gam
}

install_amxmodx() {
  # check if amxmodx is installed
  [[ -d $HLDS_DIR/cstrike/addons/amxmodx ]] && echo "AMXMODX MM already installed" && return
  # check metamod install
  [[ ! -d $HLDS_DIR/cstrike/addons/metamod ]] && echo "MetaMod not installed" && install_metamod
  
  echo "Installing AMXMODX MetaMod on game server"
  # extract amxmod
  tar xzf ~/mods/amxmodx_cs-1.8.2_linux.tar.gz -C $HLDS_DIR/cstrike/addons/
  # add amxmodx to metamod plugins list
  echo "linux addons/amxmodx/dlls/amxmodx_mm_i386.so" >> $HLDS_DIR/cstrike/addons/metamod/plugins.ini
}

install_podbot() {
  # check if podbot is installed
  [[ -d $HLDS_DIR/cstrike/addons/podbot ]] && echo "POD-bot MM already installed" && return
  # check metamod install
  [[ ! -d $HLDS_DIR/cstrike/addons/metamod ]] && echo "MetaMod not installed" && install_metamod
  
  echo "Install POD-bot MetaMod on game server"
  # extract podbot
  tar xzf ~/mods/podbot-3.0_22.tar.gz -C $HLDS_DIR/cstrike/addons/
  # add podbot to metamod plugins list
  echo "linux addons/podbot/podbot_mm_i386.so" >> $HLDS_DIR/cstrike/addons/metamod/plugins.ini
}

update() {
  echo "Updating CS:S Dedicated Server"
  ./steamcmd.sh +login anonymous +app_update 90 +quit
  echo "Update complete"
}

shutdown() {
  pkill hlds_linux
  store_config
  echo "Counter Strike 1.6 Dedicated Server Stopped"
  exit 143
}

term_handler() {
    echo "SIGTERM received"
    shutdown
}

trap term_handler SIGTERM
# Install/Update server files
[ ! -d "$HLDS_DIR/cstrike" ] && install || update

load_config

echo "Starting Counter Strike 1.6 Dedicated Server"
cd $HLDS_DIR
./hlds_run -game cstrike -strictportbind -ip 0.0.0.0 -port $PORT +sv_lan $SV_LAN +map $MAP -maxplayers $MAXPLAYERS +hostname $CS_HOSTNAME +sv_password $CS_PASSWORD +rcon_password $RCON_PASSWORD & wait ${!}

echo "Counter Strike Dedicated Server has died"
shutdown
