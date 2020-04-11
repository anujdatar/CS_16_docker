#! /bin/bash

check_metamod_install() {
  echo "Checking MetaMod installation"
  if [ -d $HLDS_DIR/cstrike/addons/metamod ]; then
    echo "MetaMod OK"
    return 0
  else
    echo "MetaMod not installed"
    install_metamod
    return
  fi
}

install_metamod() {
  # check if metamod is installed
  [ -d $HLDS_DIR/cstrike/addons/metamod ] && echo "MetaMod already installed" && return 0
  
  echo "Installing MetaMod on game server"
  if [ -f ~/addons/metamod-1.21.1.tar.gz ]; then
    mkdir -p $HLDS_DIR/cstrike/addons
    # extract metamod
    tar xzf ~/addons/metamod-1.21.1.tar.gz -C $HLDS_DIR/cstrike/addons/
    # copy liblist.gam to enable metamod on game server
    cp -fa ~/addons/liblist.gam $HLDS_DIR/cstrike/liblist.gam
    echo "MetaMod install complete"
  else 
    echo "Unable to locate $HOME/addons/metamod-1.21.1.tar.gz"
    echo "Please verify mod archive and manually copy to server"
    return 1
  fi
  return 0
}

install_amxmodx() {
  # check if amxmodx is installed
  [ -d $HLDS_DIR/cstrike/addons/amxmodx ] && echo "AMXmodX MM already installed" && return 0

  check_metamod_install
  if [ $? -eq 1 ]; then
    echo "MetaMod Install unsuccessful. Unable to install AMXmodX"
    return 1
  fi

  echo "Installing AMXmodX MetaMod on game server"
  if [ -f ~/addons/amxmodx_cs-1.8.2_linux.tar.gz ]; then
    # extract amxmod
    tar xzf ~/addons/amxmodx_cs-1.8.2_linux.tar.gz -C $HLDS_DIR/cstrike/addons/
    # add amxmodx to metamod plugins list
    echo "linux addons/amxmodx/dlls/amxmodx_mm_i386.so" >> $HLDS_DIR/cstrike/addons/metamod/plugins.ini
  else 
    echo "Unable to locate $HOME/addons/amxmodx_cs-1.8.2_linux.tar.gz"
    echo "Please verify mod archive and manually copy to server"
    return 1
  fi
  echo "AMXmodX install complete"
  return 0
}

install_podbot() {
  # check if podbot is installed
  [ -d $HLDS_DIR/cstrike/addons/podbot ] && echo "POD-bot MM already installed" && return 0

  check_metamod_install
  if [ $? -eq 1 ]; then
    echo "MetaMod Install unsuccessful. Unable to install AMXmodX"
    return 1
  fi

  echo "Install PoDBot MetaMod on game server"
  if [ -f ~/addons/podbot-3.0_22.tar.gz ]; then
    # extract podbot
    tar xzf ~/addons/podbot-3.0_22.tar.gz -C $HLDS_DIR/cstrike/addons/
    # add podbot to metamod plugins list
    echo "linux addons/podbot/podbot_mm_i386.so" >> $HLDS_DIR/cstrike/addons/metamod/plugins.ini
    # copy extra waypoints
    tar xzf ~/addons/waypoints.tar.gz -C $HLDS_DIR/cstrike/addons/podbot/
  else 
    echo "Unable to locate $HOME/addons/podbot-3.0_22.tar.gz"
    echo "Please verify mod archive and manually copy to server"
    return 1
  fi
  echo "PoDBot install complete"
  return 0
}

# copy mods to server
install_metamod
install_amxmodx
install_podbot
