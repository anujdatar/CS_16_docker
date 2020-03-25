#! /bin/bash

# basic SteamCmd install
sudo apt update && sudo apt upgrade -y

sudo apt install -y software-properties-common
sudo add-apt-repository multiverse
sudo dpkg --add-architecture i386
sudo apt update && sudo apt install -y lib32gcc1 wget curl ca-certificates

curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

mkdir -p $HOME/.steam && ln -s $HOME/linux32 $HOME/.steam/sdk32

./steamcmd.sh +login anonymous +force_install_dir /home/aj/cs_server +app_set_config 90 mod cstrike +app_update 90 validate +quit || true
./steamcmd.sh +login anonymous +app_update 70 validate +quit || true
./steamcmd.sh +login anonymous +app_update 10 validate +quit || true
./steamcmd.sh +login anonymous +force_install_dir /home/aj/cs_server +app_set_config 90 mod cstrike +app_update 90 validate +quit || true
