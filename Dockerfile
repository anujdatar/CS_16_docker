FROM cstrikemods

# copy steam and cs install/control tool to container
COPY cs_server.sh /home/steam/cs_server.sh

# mount volume for configs and scripts
RUN mkdir -p /home/steam/store && mkdir -p /home/steam/scripts
RUN chown -R steam:steam /home/steam/store && chown -R steam:steam /home/steam/scripts
VOLUME [ "/home/steam/store/", "/home/steam/scripts" ]

# expose docker ports for external use
EXPOSE $PORT/tcp
EXPOSE $PORT/udp

# run the start counter strike dedicated server and wait for input in bash
CMD ["sh", "-c", "/home/steam/cs_server.sh start & /bin/bash"]
