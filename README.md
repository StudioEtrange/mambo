# mambo

* A docker based distribution of media tools.


## Requirements

* bash
* git
* docker

NOTE : mambo will auto install docker-compose

## Usage

* install
```
git clone
cd mambo
./mambo install
```

* launch

```
./mambo up
```

* stop all

```
./mambo down
```

## Configuration

* You could set every mambo configuration value through a configuration file or shell environment variables when launching mambo. 
* Some configuration values can also be setted with mambo command line. 

* You could create and edit an `env.site` file to set any available variables
* All default values are setted in `env.default` except default values for 
    * `MAMBO_USER_ID` and `MAMBO_GROUP_ID` which are defined at mambo runtime with current unix user
    * `MAMBO_DATA_PATH`, `MAMBO_DOWNLOAD_PATH` and `MAMBO_MEDIA_PATH` which are defined at mambo runtime


* Shell environment variables override command line value which override configuration files (`env.site`) values which override default configuration files values (`env.default`)

* At each use mambo generate a `.env` file and a `env.bash` from `env.default` and `env.site` files containing exact same values. `env.bash` is used by some mambo shell scripts, `.env` is used by docker-compose.



### NOTE on `.env` file and docker-compose 


* Any `.env` file is read by docker-compose by default to replace any variable present in docker-compose file anywhere in the file but NOT for define environment variable inside running container ! For this last purpose you need to set `.env`

    ```
    test:
        image: bash:4.4.23
        command: >
            bash -c "echo from docker compose : $MAMBO_PORT_MAIN from running container env variable : $$MAMBO_PORT_MAIN"
    ```
    * This above only show MAMBO_PORT_MAIN value but $$MAMBO_PORT_MAIN (with double dollar to not have docker-compose replace value) is empty unless you add this :

    ```
    env_file:
        - .env
    ```
    


### Available Variables

* All of these variables can be configured either through conf file or through shell environment variable

|NAME|DESC|DEFAULT VALUE|SAMPLE USAGE with shell environment variable
|-|-|-|-|
|MAMBO_USER_ID|unix user which will run services and acces to files|current user `id -u`|`MAMBO_USER_ID=1000 ./mambo`|
|MAMBO_GROUP_ID|unix group which will run services and acces to files|current group `id -g`|`MAMBO_GROUP_ID=1000 ./mambo`|
|MAMBO_DOMAIN|domain used to access mambo. `.*` stands for any domain or host ip|`.*`|`MAMBO_DOMAIN="mydomain.com" ./mambo`|
|MAMBO_MEDIA_PATH|path on host that contains media files. Must exists. If relative path is relative to mambo path|`./mambo/workspace/media`|`MAMBO_MEDIA_PATH="/mnt/media" ./mambo`|
|MAMBO_DATA_PATH|path on host that contains all services conf and data files. Must exists. If relative path is relative to mambo path|`./mambo/workspace/data`|`MAMBO_DOMAIN="/home/$USER/mambo-data" ./mambo`|
|MAMBO_DOWNLOAD_PATH|path on host that contains temporary downloaded. Must exists. If relative path is relative to mambo pathh|`./mambo/workspace/download`|`MAMBO_DOWNLOAD_PATH="./temp/download" ./mambo`|



## Commands

* launch docker-compose bundled into mambo

```
./docker-compose <arg>
```



## Network configuration

* Mambo have two main endpoints `web` and `web_internal`
    * `web` entrypoint (port number defined by `MAMBO_PORT_MAIN`) is the main port to access to mambo - It is an entrypoint of traefik that allow access to organizr. You should allow its attached port to anybody in your router configuration.
    * `web_secondary` entrypoint (port number defined by `MAMBO_PORT_SECONDARY`) is a secondary port for mambo - It is an entrypoint of traefik that allow access to each services (so its bypass organizr). You should protect its attached port in your router configuration according to your needs.
    * `web_traefik` entrypoint (port number defined by `MAMBO_PORT_TRAEFIK_ADMIN`) is a secondary port for mambo - It is an entrypoint of traefik that allow access to each services (so its bypass organizr). You should protect its attached port in your router configuration according to your needs.

* TODO : As an alternative to block `web_secondary` endpoint : manage iptables rule we can use this https://github.com/colinmollenhour/docker-confd-firewall

### Web acces points

* We have 3 ways to access a service
* The first is the main door
* The second is an access to services
* The last is a direct access to services mainly for debug purposes

```
1. (host:web) traefik ==> Organizr2 ==> (host:web_internal) traefik ==> (host:docker_port_expose) Services (Ombi, Sabnzbd, ...)
2.                                  ==> (host:web_internal) traefik ==> (host:docker_port_expose) Services (Ombi, Sabnzbd, ...)
3.                                                                  ==> (host:DIRECT_ACCESS_PORT) Services (Ombi, Sabnzbd, ...)
```

* Example with ombi

```
1.  TODO
2.  http://ombi.domain:MAMBO_PORT_INTERNAL ==> http://ombi:5000
3.  http://domin:8000 ==> http://ombi:5000
```

* Direct access port can be configured through variables `DIRECT_ACCESS_PORT_*`. The first port declared as exposed is mapped to its value.

## GPU

* To confirm your host kernel supports the Intel Quick Sync feature, the following command can be executed on the host `lspci -v -s $(lspci | grep VGA | cut -d" " -f 1)` which should output `Kernel driver in use: i915` 
* If your Docker host also has a dedicated graphics card, the video encoding acceleration of Intel Quick Sync Video may become unavailable when the GPU is in use. 
* If your computer has an NVIDIA GPU, please install the latest Latest NVIDIA drivers for Linux to make sure that Plex can use your NVIDIA graphics card for video encoding (only) when Intel Quick Sync Video becomes unavailable.


## Notes

* I tried my best to stick to docker-compose file features and write less bash code. But in the end, docker-compose files are not great when dealing with conf and env var... and I fallback to bash.

* cannot use 3.x docker compose version, while `--runtime` or `--gpus` are not supported in docker compose format (https://github.com/docker/compose/issues/6691)

## Links

* MEDIA STACK on DOCKER with TRAEFIK https://gist.github.com/anonymous/66ff223656174fd39c76d6075d6535fd
* TRAEFIK GUIDES 
    * https://medium.com/@containeroo/traefik-2-0-docker-an-advanced-guide-d098b9e9be96
    * https://blog.eleven-labs.com/fr/utiliser-traefik-comme-reverse-proxy/
*  ORGANIZR2 and NGINX
    * translate this nginx to traefik: https://guydavis.github.io/2019/01/03/nginx_organizr_v2/
* Traefik forward auth and keycloak https://geek-cookbook.funkypenguin.co.nz/ha-docker-swarm/traefik-forward-auth/keycloak/
* Traefik anad oauth2 proxy https://geek-cookbook.funkypenguin.co.nz/reference/oauth_proxy/
* Media distribution
    * cloudbox https://github.com/Cloudbox/Cloudbox - docker based - ansible config script for service and install guide for each service
    * openflixr https://www.openflixr.com/ - full VM
    * autopirate https://geek-cookbook.funkypenguin.co.nz/recipes/autopirate/ - docker based - use traefik + oauth2 proxy



## TODO

* plex settings
    * quality settings  https://github.com/Cloudbox/Cloudbox/blob/master/roles/plex/tasks/subtasks/extra.yml https://github.com/Cloudbox/Cloudbox/blob/master/roles/plex/tasks/subtasks/settings/forced_quality.yml
    * other settings : https://github.com/Cloudbox/Cloudbox/blob/master/roles/plex/tasks/subtasks/preferences/preferences.yml (fix /transcode folder AND claim server)
* backup https://geek-cookbook.funkypenguin.co.nz/recipes/duplicity/