#! /bin/bash

echo "Running custom scripts for additional setup"

# Install de_minidust2 and aa_dima maps
echo "Installing \"Mini Dust 2\" and \"Dima\" maps"
tar xzf ~/custom_scripts/minidust_dima.tar.gz -C $HLDS_DIR/cstrike

# Install aim maps for CS 1.6
echo "Installing AIM masps"
tar xzf ~/custom_scripts/aim_maps.tar.gz -C $HLDS_DIR
