# MAMBO

* A docker traefik based media stack


## REQUIREMENTS

* bash
* git
* docker

If you want to use hardware transcode on nvidia gpu :

* nvidia-docker

NOTE : mambo will auto install docker-compose

## SERVICES

* Plex
* Ombi
* Sabnzbd
* Medusa
* Tautulli
* Organizr2

## USAGE


NOTE : some default values will be used. so it will just works.

* Install

    ```
    git clone https://github.com/StudioEtrange/mambo
    cd mambo
    ./mambo install
    ```

* First initialization

    ```
    PLEX_USER=no@no.com PLEX_PASSWORD=**** ./mambo init
    ```

* Launch

    ```
    ./mambo up
    ```

* Stop all

    ```
    ./mambo down
    ```

## MAMBO CONFIGURATION

* You could set every mambo configuration variables through a configuration file or shell environment variables when launching mambo. 

* Variables can be configured either through conf file or through shell environment variable
* Shell environment variables override command line value which override your configuration files values which override default configuration files values

* All default values are setted with defaults values in `env.default` except
    * `MAMBO_USER_ID` and `MAMBO_GROUP_ID` which are defined at mambo runtime with current unix user
    * `MAMBO_DATA_PATH`, `MAMBO_DOWNLOAD_PATH` which are defined at mambo runtime



### Standard variables


|NAME|DESC|DEFAULT VALUE|SAMPLE VALUE|
|-|-|-|-|
|MAMBO_DOMAIN|domain used to access mambo. `.*` stands for any domain or host ip.|`.*`|`mydomain.com`|
|MAMBO_USER_ID|unix user which will run services and acces to files.|current user `id -u`|`1000`|
|MAMBO_GROUP_ID|unix group which will run services and acces to files.|current group `id -g`|`1000`|
|MAMBO_MEDIA_FOLDERS|list of paths on host that contains media files. Must exists. If relative path is relative to mambo path|`./mambo/workspace/media`|`/mnt/MEDIA/MOVIES /mnt/MEDIA/TV_SHOWS`|
|MAMBO_DATA_PATH|path on host for services conf and data files. Relative to mambo app path.|`./mambo/workspace/data`|`../data`|
|MAMBO_DOWNLOAD_PATH|path on host for downloaded files. Relative to mambo app path.|`./mambo/workspace/download`|`../download`|
|PLEX_USER|your plex account|-|`no@no.com`|
|PLEX_PASSWORD|your plex password|-|`mypassword`|

### Advanced variables

* see `env.default` for detail

* TO BE COMPLETED


### Using a conf file

* You could create a conf file (ie: `mambo.env`) to set any available variables and put it everywhere. By default it will be looked for from your home directory

    ```
    ./mambo -f $HOME/mambo.site up
    ```

* A conf file syntax is liked docker-compose env file syntax. It is **NOT** a shell file. Values are not evaluated.


    ```
    MAMBO_PORT_MAIN=80
    MAMBO_DATA_PATH=../mambo-data
    MAMBO_DOWNLOAD_PATH=../mambo-download
    MAMBO_MEDIA_FOLDERS=/mnt/MEDIA/MOVIES /mnt/MEDIA/TV_SHOWS
    ```


### Using shell environment variables

* Set variables at mambo launch or export them before launch

    ```
    MAMBO_DOMAIN="mydomain.com" MAMBO_DATA_PATH="/home/$USER/mambo-data" ./mambo up
    ```


### For Your Information about env files


* At each launch mambo use `env.default` file and your conf file (`mambo.env`) files to generate
    * `.env` file used by docker-compose
    * `env.bash` file used by mambo shell scripts


* You may know that a `.env` file is read by docker-compose by default to replace any variable present in docker-compose file anywhere in the file but NOT for define shell environment variable inside running container ! 


    ```
    test:
        image: bash:4.4.23
        command: >
            bash -c "echo from docker compose : $MAMBO_PORT_MAIN from running container env variable : $$MAMBO_PORT_MAIN"
    ```

    * This above only show MAMBO_PORT_MAIN value but $$MAMBO_PORT_MAIN (with double dollar to not have docker-compose replace the value) is empty unless you add this :

    ```
    test:
        image: bash:4.4.23
        env_file:
            - .env
        command: >
            bash -c "echo from docker compose : $MAMBO_PORT_MAIN from running container env variable : $$MAMBO_PORT_MAIN"
    ```

## SERVICE MANIPULATION

### Enable/disable

* To enable/disable a service, use variable `SERVICE_*`
    * to enable use the service name as value 
    * to disable add `_disable` to service name

* ie in conf file : 
    ```
    SERVICE_OMBI=ombi
    SERVICE_SABNZBD=sabnzbd_disable
    ```

### Start/stop a service

* Launch a specific service

    ```
    ./mambo up <service> [-d]
    ```

* Stop a service

    ```
    ./mambo down <service>
    ```

## HTTP/HTTPS CONFIGURATION

* For enable HTTPS only access to each service, declare them in `MAMBO_SERVICES_REDIRECT_HTTPS` variable
* A certificate will be autogenerate -- TO BE COMPLETED letsencrypt --

* NOTE : some old plex client do not support HTTPS (like playstation 3)

* ie in conf file : 
    ```
    MAMBO_SERVICES_REDIRECT_HTTPS=ombi organizr2
    ```

## SERVICES CONFIGURATION

* You need to configure each service. Mambo do only a few configuration on some services. 
* Keep in mind that each service is reached from other one with url like `http://<service>:<default service port>` (ie `http://ombi:5000`)


### Various configuration guides

* Plex https://github.com/Cloudbox/Cloudbox/wiki/Install%3A-Plex-Media-Server
* Ombi https://github.com/Cloudbox/Cloudbox/wiki/Install%3A-Ombi



## AVAILABLE COMMANDS

```
L     install : deploy this app
L     up [service [-d]] : launch all mambo services or one service
L     down [service] : down all mambo services or one service
L     restart [service [-d]] : restart all mambo services or one service
L     info : give info on Mambo. Will generate conf files and print configuration used when launching any service.
L     status [service] : see status
L     logs [service] : see logs
L     shell <service> : launch a shell into a running service
L     init : init services. Do it once before launch. - will stop plex
```



## NETWORK CONFIGURATION

### Logical area

* Mambo have 3 logical areas. `main`, `secondary` and `admin`. Each of them have a HTTP entrypoint and a HTTPS entrypoint. 
* So you can separate each service on different area according to your needs by opening/closing your router settings

* By default
    * all services are on `main` area, so accessible throuh ports 80/443 (ie: http://ombi.mydomain.com)
    * traefik admin services are on `main` area, so accessible throuh ports 30443 (only, no HTTP for traefik admin) (ie: http://traefik.mydomain.com)

### Avaibale areas and entrypoints

|logical area|entrypoint name|protocol|default port|variable|
|-|-|-|-|-|
|main|web_main|HTTP|80|MAMBO_PORT_MAIN|
|main|web_main_secure|HTTPS|443|MAMBO_PORT_MAIN_SECURE|
|secondary|web_secondary|HTTP|20000|MAMBO_PORT_SECONDARY|
|secondary|web_secondary_secure|HTTPS|20443|MAMBO_PORT_SECONDARY_SECURE|
|admin|web_admin|HTTP|30000|MAMBO_PORT_ADMIN|
|admin|web_admin_secure|HTTPS|30443|MAMBO_PORT_ADMIN_SECURE|

### Sample usage

* With these logical areas, you could setup different topology.

* Example : if `ombi` and `medusa` must be access only through `organirz2` split services on different logical area and open your router port only for `main` area (HTTP/HTTPS port)
    ```
    MAMBO_SERVICES_ENTRYPOINT_MAIN=organizr2
    MAMBO_SERVICES_ENTRYPOINT_SECONDARY=ombi medusa sabnzbd
    ```

### Direct access port for debuging purpose


* For debugging, you can declare a direct access HTTP port to the service without using traefik with variables `*_DIRECT_ACCESS_PORT`. The first port declared as exposed in docker-compose file is mapped to its value.

    * access directly throuh http://host:7777
    ```
    OMBI_DIRECT_ACCESS_PORT=7777
    ```



## GPU


### Information

* To confirm your host kernel supports the Intel Quick Sync feature, the following command can be executed on the host `lspci -v -s $(lspci | grep VGA | cut -d" " -f 1)` which should output `Kernel driver in use: i915` 
* If your Docker host also has a dedicated graphics card, the video encoding acceleration of Intel Quick Sync Video may become unavailable when the GPU is in use. 
* If your computer has an NVIDIA GPU, please install the latest Latest NVIDIA drivers for Linux to make sure that Plex can use your NVIDIA graphics card for video encoding (only) when Intel Quick Sync Video becomes unavailable.


## SIDE NOTES

* I tried my best to stick to docker-compose file features and write less bash code. But very quickly I gave up, docker-compose files is very bad when dealing with conf and env var.
* I cannot use 3.x docker compose version, while `--runtime` or `--gpus` are not supported in docker compose format (https://github.com/docker/compose/issues/6691)

## LINKS

* Some traefik guides
    * https://medium.com/@containeroo/traefik-2-0-docker-an-advanced-guide-d098b9e9be96
    * https://blog.eleven-labs.com/fr/utiliser-traefik-comme-reverse-proxy/
* Organizr2 and nginx
    * translate this nginx to traefik: https://guydavis.github.io/2019/01/03/nginx_organizr_v2/
* Traefik forward auth and keycloak https://geek-cookbook.funkypenguin.co.nz/ha-docker-swarm/traefik-forward-auth/keycloak/
* Traefik anad oauth2 proxy https://geek-cookbook.funkypenguin.co.nz/reference/oauth_proxy/
* Media distribution
    * cloudbox https://github.com/Cloudbox/Cloudbox - docker based - ansible config script for service and install guide for each service
    * openflixr https://www.openflixr.com/ - full VM
    * autopirate https://geek-cookbook.funkypenguin.co.nz/recipes/autopirate/ - docker based - use traefik + oauth2 proxy
    * a media stack on docker with traefik https://gist.github.com/anonymous/66ff223656174fd39c76d6075d6535fd
    * https://github.com/ghostserverd/mediaserver-docker/blob/master/docker-compose.yml
* Let's encrypt challenge types : https://letsencrypt.org/fr/docs/challenge-types/


## TODO

* plex plugins https://github.com/Cloudbox/Cloudbox/blob/master/roles/webtools-plugin/tasks https://github.com/Cloudbox/Cloudbox/tree/master/roles/trakttv-plugin/tasks
* backup https://geek-cookbook.funkypenguin.co.nz/recipes/duplicity/

* show gpu usage stat
    ```
    /usr/lib/plexmediaserver/Plex\ Transcoder -codecs
    /usr/lib/plexmediaserver/Plex\ Transcoder -encoders
    nvidia-smi -q -g 0 -d UTILIZATION -l
    ```
* show plex transcode custom ffmpeg

    ```
    /usr/lib/plexmediaserver/Plex\ Transcoder 
    -formats            show available formats
    -muxers             show available muxers
    -demuxers           show available demuxers
    -devices            show available devices
    -codecs             show available codecs
    -decoders           show available decoders
    -encoders           show available encoders
    -bsfs               show available bit stream filters
    -protocols          show available protocols
    -filters            show available filters
    -pix_fmts           show available pixel formats
    -layouts            show standard channel layouts
    -sample_fmts        show available audio sample formats
    -colors             show available color names
    -hwaccels           show available HW acceleration methods

    ```

* unlock non pro nvidia gpu https://github.com/keylase/nvidia-patch