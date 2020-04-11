#! /bin/bash

# Install map packs
echo "Installing map packs"
# Install de_minidust2 and aa_dima maps
echo "Installing minidust2 and dima maps"
if [ -f ~/addons/minidust_dima.tar.gz ]; then
  tar xzf ~/addons/minidust_dima.tar.gz -C $HLDS_DIR/cstrike
else
  echo "Unable to locate $HOME/addons/minidust_dima.tar.gz"
  echo "Please verify map archive and manually copy to server"
fi

# Install aim maps for CS 1.6
echo "Installing AIM map pack"
if [ -f ~/addons/aim_maps.tar.gz ]; then
  tar xzf ~/addons/aim_maps.tar.gz -C $HLDS_DIR
else
  echo "Unable to locate $HOME/addons/aim_maps.tar.gz"
  echo "Please verify map archive and manually copy to server"
fi

# Install Untitled maps
echo "Installing Untitled map pack"
if [ -f ~/addons/cs_untitled_1_2.tar.gz ]; then
  tar xzf ~/addons/cs_untitled_1_2.tar.gz -C $HLDS_DIR
else
  echo "Unable to locate $HOME/addons/cs_untitled_1_2.tar.gz"
  echo "Please verify map archive and manually copy to server"
fi

echo "Map packs installed"
