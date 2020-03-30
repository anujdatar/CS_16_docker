#! /bin/bash
source $(pwd)/store/constants.sh
# SCRIPT_HOME=$(pwd)

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
  tar xzf $MODS_DIR/metamod-1.21.1.tar.gz -C $HLDS_DIR/cstrike/addons/
  # copy liblist.gam to enable metamod on game server
  cp -fa $MODS_DIR/liblist.gam $HLDS_DIR/cstrike/liblist.gam
}

install_amxmodx() {
  # check if amxmodx is installed
  [[ -d $HLDS_DIR/cstrike/addons/amxmodx ]] && echo "AMXMODX MM already installed" && return
  # check metamod install
  [[ ! -d $HLDS_DIR/cstrike/addons/metamod ]] && echo "MetaMod not installed" && install_metamod
  
  echo "Installing AMXMODX MetaMod on game server"
  # extract amxmod
  tar xzf $MODS_DIR/amxmodx_cs-1.8.2_linux.tar.gz -C $HLDS_DIR/cstrike/addons/
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
  tar xzf $MODS_DIR/podbot-3.0_22.tar.gz -C $HLDS_DIR/cstrike/addons/
  # add podbot to metamod plugins list
  echo "linux addons/podbot/podbot_mm_i386.so" >> $HLDS_DIR/cstrike/addons/metamod/plugins.ini
}

update() {
  echo "Updating CS:S Dedicated Server"
  ./steamcmd.sh +login anonymous +app_update 90 +quit
  echo "Update done"
}

shutdown() {
  pkill hlds_linux
  echo "Counter Strike 1.6 Dedicated Server Stopped"
  exit 143
}

# Install/Update server files
[ ! -d "$HLDS_DIR/cstrike" ] && install || update

echo "Starting Counter Strike 1.6 Dedicated Server"

cd $HLDS_DIR
./hlds_run -game cstrike -strictportbind -ip 0.0.0.0 -port $PORT +sv_lan $SV_LAN +map $MAP -maxplayers $MAXPLAYERS +hostname $CS_HOSTNAME +sv_password $CS_PASSWORD +rcon_password $RCON_PASSWORD
