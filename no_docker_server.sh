#! /bin/bash
# basic steam CMD install

# Install dependencies
sudo apt -qq update && sudo apt -qqy upgrade
sudo apt install -qqy software-properties-common
sudo add-apt-repository multiverse
sudo dpkg --add-architecture i386
sudo apt -qq update && sudo apt -qqy install lib32gcc1 wget curl ca-certificates

# Manually install steam CMD
SCRIPT_HOME=$(pwd)
STEAMCMD_DIR=$(echo $HOME/steam_commander)
mkdir $STEAMCMD_DIR && cd $STEAMCMD_DIR
curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

# steam config and links
mkdir -p $HOME/.steam
ln -s $STEAMCMD_DIR/linux32 $HOME/.steam/sdk32
# mkdir -p $HOME/.local/bin
# ln -s $STEAMCMD_DIR/steamcmd.sh $HOME/.local/bin/steamcmd
# source ~/.profile
cd $SCRIPT_HOME
./steam_commander.sh