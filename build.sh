#! /bin/bash

if [ -z $(docker images | grep ubuntubase) ]; then
  docker build -t ubuntubase -f Dockerfile.base .
fi

if [ -z $(docker images | grep steamcmdbase) ]; then
  docker build -t steamcmdbase -f Dockerfile.steamcmd .
fi

if [ -z $(docker images | grep cstrikemods) ]; then
  docker build -t cstrikemods -f Dockerfile.cstrikemods .
fi

if [ -z $(docker images | grep aj/cstrikeds) ]; then
  docker build -t aj/cstrikeds .
fi
