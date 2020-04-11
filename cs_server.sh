#! /bin/bash

# Script to manage the Counter Strike 1.6 Dedicated Server

load_config() {
  echo "Loading server configs"
  yes | cp -rfa ~/store/cfgs/* ~/hlds/cstrike/
}

store_config() {
  echo "Storing server configs"
  [ ! -d "~/store/cfgs" ] && mkdir -p ~/store/cfgs || true
  yes | cp -rfa ~/hlds/cstrike/server.cfg ~/store/cfgs/server.cfg
  yes | cp -rfa ~/hlds/cstrike/custom_server.cfg ~/store/cfgs/custom_server.cfg
  yes | cp -rfa ~/hlds/cstrike/listip.cfg ~/store/cfgs/listip.cfg
  yes | cp -rfa ~/hlds/cstrike/banned.cfg ~/store/cfgs/banned.cfg

  [ ! -d "~/store/cfgs/addons/podbot" ] && mkdir -p ~/store/cfgs/addons/podbot || true
  yes | cp -rfa ~/hlds/cstrike/addons/podbot/podbot.cfg ~/store/cfgs/addons/podbot/podbot.cfg
}

update() {
  cd $STEAMCMD_DIR
  echo "Updating CS:S Dedicated Server"
  ./steamcmd.sh +login anonymous +app_update 90 +quit
  echo "Update complete"
}

start() {
  # check Counter Strike 1.6 Dedicated Server install
  echo "Checking Counter Strike 1.6 Dedicated Server installation"
  [ ! -d "$HLDS_DIR/cstrike" ] && install || echo "Counter Strike 1.6 Dedicated Server installed"
  
  # check if hlds is running
  [ -n "$(pidof hlds_run)" ] && echo "Counter Strike 1.6 Dedicated Server is already running on port:$PORT" && return 1

  # load server constants
  [ -f ~/store/constants.sh ] && source ~/store/constants.sh || true

  load_config

  echo "Starting Counter Strike 1.6 Dedicated Server"
  cd $HLDS_DIR
  ./hlds_run -game cstrike -strictportbind -ip 0.0.0.0 -port $PORT +sv_lan $SV_LAN +map $MAP -maxplayers $MAXPLAYERS +hostname $CS_HOSTNAME +sv_password $CS_PASSWORD +rcon_password $RCON_PASSWORD &
}

stop() {
  # check if hlds is running
  [ -z "$(pidof hlds_linux)" ] && echo "Counter Strike 1.6 Dedicated Server not running" && return 1
  pkill hlds_linux
  pkill hlds_run
  store_config
  echo "Counter Strike 1.6 Dedicated Server has been stopped"
  exit 0
}

restart() {
  # check if hlds is running
  [ -z "$(pidof hlds_linux)" ] && echo "Counter Strike 1.6 Dedicated Server not running" && return 1
  echo "Restarting Counter Strike 1.6 Dedicated Server"
  store_config
  pkill hlds_linux
}

term_handler() {
    echo -e "\nSIGTERM/SIGINT received"
    stop
}

trap term_handler SIGINT
trap term_handler SIGTERM

case $1 in
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
    echo "  restart: restart cstrike server"
    echo "  update: update cstrike server"
    ;;
esac
