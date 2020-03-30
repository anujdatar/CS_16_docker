 
FROM ubuntu:latest

# ENV vars for relevant directories
ENV STEAMCMD_DIR "/home/steam/steamcmd"
ENV HLDS_DIR "/home/steam/hlds"

# basic dependency install
RUN apt -qq update && apt -qqy upgrade
RUN apt -qqy install software-properties-common
RUN add-apt-repository multiverse
RUN dpkg --add-architecture i386
RUN apt -qq update && apt -qqy install lib32gcc1 wget ca-certificates

# user setup
RUN useradd -m steam
WORKDIR /home/steam
USER steam

# Install steamcmd manually : multiverse needs EULA acceptance, won't work in docker
RUN mkdir -p $STEAMCMD_DIR
WORKDIR $STEAMCMD_DIR
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

RUN mkdir -p ~/.steam
RUN ln -s $STEAMCMD_DIR/linux32 ~/.steam/sdk32

# copy steam and cs install/control tool to container
COPY ./steam_commander.sh ~/steam_commander.sh

# copy mods folder to container
COPY ./mods ~/mods

# Copy configs
# COPY server.cfg cstrike/

# Install aim maps
# COPY AimMapCs1.6/cstrike cstrike/

# expose docker ports for external use
EXPOSE $PORT/tcp
EXPOSE $PORT/udp

# run the steamcmd and counter strike controller script
CMD [ "~/steam_commander.sh" ]
