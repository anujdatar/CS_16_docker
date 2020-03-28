 
FROM ubuntu:latest

# Default env variables
ENV PORT 27015
ENV MAP de_dust2
ENV MAXPLAYERS 16
ENV SV_LAN 0
# Server connection credentials
ENV CS_HOSTNAME 63Encore
ENV CS_PASSWORD ""
ENV RCON_PASSWORD loda

RUN apt -qq update && apt -qqy upgrade
RUN apt -qqy install software-properties-common
RUN add-apt-repository multiverse
RUN dpkg --add-architecture i386
RUN apt -qq update && apt -qqy install lib32gcc1 wget ca-certificates

RUN useradd -m steam
WORKDIR /home/steam
USER steam

# Install steamcmd from multiverse repository
# RUN apt install -y steamcmd
# RUN ln -s /usr/games/steamcmd steamcmd

# Install steamcmd manually
RUN wget -nv https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && \
    tar -xvzf steamcmd_linux.tar.gz

# Install Counter Strike 1.6 Dedicated Server
RUN /home/steam/steamcmd.sh +login anonymous +force_install_dir /home/steam/cs16 +app_set_config 90 mod cstrike +app_update 90 validate +quit || true
RUN /home/steam/steamcmd.sh +login anonymous +force_install_dir /home/steam/cs16 +app_update 70 validate +quit || true
RUN /home/steam/steamcmd.sh +login anonymous +force_install_dir /home/steam/cs16 +app_update 10 validate +quit || true
RUN /home/steam/steamcmd.sh +login anonymous +force_install_dir /home/steam/cs16 +app_set_config 90 mod cstrike +app_update 90 validate +quit

RUN mkdir -p ~/.steam && ln -s ~/linux32 ~/.steam/sdk32

WORKDIR /home/steam/cs16

# Add metamod
# RUN mkdir -p cstrike/addons/metamod/dlls
# COPY metamod_i386.so cstrike/addons/metamod/dlls/
# COPY metamod.so cstrike/addons/metamod/dlls/

# Add bots
# COPY podbot cstrike/addons/podbot
# RUN echo "linux addons/podbot/podbot_mm_i386.so" > cstrike/addons/metamod/plugins.ini
# COPY liblist.gam cstrike/

# Copy configs
COPY server.cfg cstrike/

# Install aim maps
# COPY AimMapCs1.6/cstrike cstrike/

EXPOSE $PORT/tcp
EXPOSE $PORT/udp

CMD ./hlds_run -game cstrike -strictportbind -autoupdate -ip 0.0.0.0 +sv_lan $SV_LAN +map $MAP -maxplayers $MAXPLAYERS -port $PORT +hostname $CS_HOSTNAME +rcon_password $RCON_PASSWORD
