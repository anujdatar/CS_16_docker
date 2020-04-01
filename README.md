# CS_16_docker

Counter Strike 1.6 server using docker

## Usage

1. clone repository

2. Build docker image
    ```bash
    docker build -t <image-name/tag> .
    ```

3. Edit Server configs
    - ./store/constants.sh -> starting map, server name, passwords
    - ./store/cfgs/*.cfg -> banned players, ips, other server settings

4. Run docker container
    ```bash
    docker run -it --name <container-name> -v $(pwd)/store:/home/steam/store/ -v $(pwd)/scripts:/home/steam/scripts -p 27015:27015 -p 27015:27015/udp <image-name/tag>
    ```

5. Container boots to bash. you can now run the server management script
    ```bash
    ./cs_server.sh start
    or
    ./cs_server.sh stop
    or
    ./cs_server.sh restart
    or
    ./cs_server.sh update
    ```

6. You can also run it with the `-d` (detatched) flag, and just run `docker exec <container-name> sh -c"/home/steam/cs_server.sh start"` etc...
