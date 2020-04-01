 
FROM ubuntu:latest

# ENV vars for relevant directories
ENV STEAMCMD_DIR "/home/steam/steamcmd"
ENV HLDS_DIR "/home/steam/hlds"
ENV PORT 27015
ENV DEBIAN_FRONTEND noninteractive

# basic dependency install
RUN apt -qq update && apt -qqy upgrade
RUN apt -qqy install software-properties-common apt-utils
RUN apt -qqy install wget curl ca-certificates locales
RUN add-apt-repository multiverse
RUN dpkg --add-architecture i386
RUN apt -qq update && apt -qqy install lib32gcc1

# fixing locale error
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
# ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
RUN locale-gen en_US.UTF-8
RUN yes 158 | dpkg-reconfigure locales

# user setup
RUN useradd -m steam
WORKDIR /home/steam
USER steam

# Install steamcmd manually : multiverse needs EULA acceptance, won't work in docker
RUN mkdir -p $STEAMCMD_DIR
WORKDIR $STEAMCMD_DIR
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

RUN mkdir -p /home/steam/.steam
RUN ln -s $STEAMCMD_DIR/linux32 /home/steam/.steam/sdk32

# copy steam and cs install/control tool to container
COPY cs_server.sh /home/steam/cs_server.sh

# copy mods folder to container
COPY mods /home/steam/mods

# Install aim maps
# COPY AimMapCs1.6/cstrike cstrike/

# expose docker ports for external use
EXPOSE $PORT/tcp
EXPOSE $PORT/udp

# mount volume for configs and scripts
RUN mkdir -p /home/steam/store
RUN mkdir -p /home/steam/scripts
RUN chown -R steam:steam /home/steam/store
RUN chown -R steam:steam /home/steam/scripts
VOLUME [ "/home/steam/store/", "/home/steam/scripts" ]

# run the steamcmd counter strike installer and wait for input
WORKDIR /home/steam/
RUN "./cs_server.sh" "install"
CMD [ "bash" ]
