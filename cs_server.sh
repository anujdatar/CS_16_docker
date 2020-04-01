#! /bin/bash

# Script to manage the Counter Strike 1.6 Dedicated Server

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
  # both AppIDs 70 - hl1, 10- cs1.6 need logins cant use here
  # AppID 90 is for Counter Strike 1.6 Dedicatd Server
  # ./steamcmd.sh +login anonymous +app_update 70 +quit || true
  # ./steamcmd.sh +login anonymous +app_update 10 +quit || true
  ./steamcmd.sh +login anonymous +force_install_dir $HLDS_DIR +app_set_config 90 mod cstrike +app_update 90 validate +quit || true

  # copy mods to server
  install_metamod
  install_amxmodx
  install_podbot

  # Install map packs
  echo "Installing map packs"
  \. /home/steam/scripts/install_map_pack.sh;;

  echo "Installation complete"
}

install_metamod() {
  # check if metamod is installed
  [ -d $HLDS_DIR/cstrike/addons/metamod ] && echo "MetaMod already installed" && return
  
  echo "Installing MetaMod on game server"
  mkdir -p $HLDS_DIR/cstrike/addons
  # extract metamod
  tar xzf ~/mods/metamod-1.21.1.tar.gz -C $HLDS_DIR/cstrike/addons/
  # copy liblist.gam to enable metamod on game server
  cp -fa ~/mods/liblist.gam $HLDS_DIR/cstrike/liblist.gam
}

install_amxmodx() {
  # check if amxmodx is installed
  [ -d $HLDS_DIR/cstrike/addons/amxmodx ] && echo "AMXMODX MM already installed" && return
  # check metamod install
  [ ! -d $HLDS_DIR/cstrike/addons/metamod ] && echo "MetaMod not installed" && install_metamod
  
  echo "Installing AMXMODX MetaMod on game server"
  # extract amxmod
  tar xzf ~/mods/amxmodx_cs-1.8.2_linux.tar.gz -C $HLDS_DIR/cstrike/addons/
  # add amxmodx to metamod plugins list
  echo "linux addons/amxmodx/dlls/amxmodx_mm_i386.so" >> $HLDS_DIR/cstrike/addons/metamod/plugins.ini
}

install_podbot() {
  # check if podbot is installed
  [ -d $HLDS_DIR/cstrike/addons/podbot ] && echo "POD-bot MM already installed" && return
  # check metamod install
  [ ! -d $HLDS_DIR/cstrike/addons/metamod ] && echo "MetaMod not installed" && install_metamod
  
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

start() {
  # check Counter Strike 1.6 Dedicated Server install
  echo "Checking Counter Strike 1.6 Dedicated Server installation"
  [ ! -d "$HLDS_DIR/cstrike" ] && install || echo "Counter Strike 1.6 Dedicated Server installed"

  # load server constants
  source ~/store/constants.sh

  load_config

  echo "Starting Counter Strike 1.6 Dedicated Server"
  cd $HLDS_DIR
  ./hlds_run -game cstrike -strictportbind -ip 0.0.0.0 -port $PORT +sv_lan $SV_LAN +map $MAP -maxplayers $MAXPLAYERS +hostname $CS_HOSTNAME +sv_password $CS_PASSWORD +rcon_password $RCON_PASSWORD & # wait ${!}
  # echo "Counter Strike Dedicated Server has died"
  # stop
}

stop() {
  [ ! -z "$(pidof hlds_run)" ] && echo "Counter Strike 1.6 Dedicated Server not running" && return
  pkill hlds_linux
  pkill hlds_run
  store_config
  echo "Counter Strike 1.6 Dedicated Server has been stopped"
  exit 143
}

restart() {
  [ ! -z "$(pidof hlds_run)" ] && echo "Counter Strike 1.6 Dedicated Server not running" && return
  echo "Restarting Counter Strike 1.6 Dedicated Server"
  store_config
  pkill hlds_linux
}

term_handler() {
    echo "SIGTERM received"
    stop
}

# trap term_handler SIGTERM

case $1 in
  install)
    install;;
  update)
    update;;
  start)
    start;;
  stop)
    stop;;
  restart)
    restart;;
  *)
    echo "Usage: ./cs_server.sh [COMMAND]"
    echo "Available commands:"
    echo "  start: start cstrike server"
    echo "  stop: stop cstrike server"
    echo "  update: update cstrike server"
    echo "  addons: install addons and maps";;
esac
