# MAMBO - A docker based media stack


* Support nvidia transcoding for plex
* Support Let's encrypt for HTTPS certificate generation
* Configurable through env variables or env file
* Highly based on traefik2 for internal routing

## REQUIREMENTS

* bash 4
* git
* docker

If you want to use hardware transcode on nvidia gpu :

* nvidia-docker

NOTE : mambo will auto install other tools like docker-compose

## SERVICES INCLUDED

* Plex - media center
* Ombi - user request content  
* Sabnzbd - newzgroup download
* Medusa - tv episodes search and subtitles management
* Tautulli - plex statistics and newsletter
* JDownloader2 - direct download manager
* Organizr2


## USAGE


### First steps
* Install

    ```
    git clone https://github.com/StudioEtrange/mambo
    cd mambo
    ./mambo install
    ```

* First initialization

    ```
    PLEX_USER="no@no.com" PLEX_PASSWORD="****" ./mambo init
    ```


### Minimal configuration

* Create a `mambo.env` file with
    ```
    PLEX_USER=no@no.com
    PLEX_PASSWORD=****
    MAMBO_DOMAIN=mydomain.com
    ```

* For HTTPS only access, add 
    ```
    LETS_ENCRYPT=enable
    LETS_ENCRYPT_MAIL=no@no.com

    MAMBO_SERVICES_REDIRECT_HTTPS=traefik ombi sabnzbd tautulli medusa
    ```

* Launch
    ```
    ./mambo up -f mambo.env
    ```


* Stop all
    ```
    ./mambo down
    ```

## AVAILABLE COMMANDS

```
L     install : deploy this app
L     init [--claim] : init services. Do it once before launch. - will stop plex --claim : will force to claim server even it is already registred
L     up [service [-d]] : launch all mambo services or one service
L     down [service] : down all mambo services or one service
L     restart [service [-d]] : restart all mambo services or one service
L     info : give info on Mambo. Will generate conf files and print configuration used when launching any service.
L     status [service] : see status
L     logs [service] : see logs
L     shell <service> : launch a shell into a running service
```




## MAMBO CONFIGURATION

* You could set every mambo variables through a user environment file, shell environment variables and some from command line. 


* All existing variables are listed in `env.default`

* Resolution priority order :
    * Command line variables
    * Shell environment variables
    * User environment file variables
    * Default configuration file variables
    * Default values from mambo itself




### Standard variables


|NAME|DESC|DEFAULT VALUE|SAMPLE VALUE|
|-|-|-|-|
|MAMBO_DOMAIN|domain used to access mambo. It is a regexp. `.*` stands for any domain or host ip.|`.*`|`mydomain.com`|
|MAMBO_USER_ID|unix user which will run services and acces to files.|current user : `id -u`|`1000`|
|MAMBO_GROUP_ID|unix group which will run services and acces to files.|current group : `id -g`|`1000`|
|MAMBO_MEDIA_FOLDERS|list of paths on host that contains media files. Relative path to mambo app path|-|`/mnt/MEDIA/MOVIES /mnt/MEDIA/TV_SHOWS`|
|MAMBO_DATA_PATH|path on host for services conf and data files. Relative to mambo app path.|`./mambo/workspace/data`|`../data`|
|MAMBO_DOWNLOAD_PATH|path on host for downloaded files. Relative to mambo app path.|`./mambo/workspace/download`|`../download`|
|PLEX_USER|your plex account|-|`no@no.com`|
|PLEX_PASSWORD|your plex password|-|`mypassword`|

### Advanced variables

* see `env.default` for detail

* TODO TO BE COMPLETED


### Using a user environment file

* You could create a user environment file (default name : `mambo.env`) to set any available variables and put it everywhere. By default it will be looked for from your home directory

    ```
    ./mambo -f mambo.env up
    ```

* By default, mambo will look for any existing user environment file into `$HOME/mambo.env`

* A user environment file syntax is liked docker-compose env file syntax. It is **NOT** a shell file. Values are not evaluated.


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


### For Your Information about env files - internal mechanisms


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

## SERVICE ADMINISTRATION

### Enable/disable

* To enable/disable a service, use variable `SERVICE_*`
    * to enable use the service name as value 
    * to disable add `_disable` to service name

* ie in user env file : 
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

## SERVICES CONFIGURATION

* You need to configure yourself each service. Mambo do only a few configurations on some services. 
* Keep in mind that each service is reached from other one with url like `http://<service>:<default service port>` (ie `http://ombi:5000`)

### Plex

* Guide https://github.com/Cloudbox/Cloudbox/wiki/Install%3A-Plex-Media-Server

### Tautulli

* access to tautulli - setup wizard will be launched
* create an admin account
* signin with your plex account
* For Plex Media Server :
    * Plex IP or Hostname : `plex`
    * Port Number : `32400`
    * Use SSL : `disabled`
    * Remote Server : `disabled`
    * Click Verify
* Then after setup finished, in settings
    * Web interface / advanced settings / Enable HTTP Proxy : `enabled`
    * Web interface / advanced settings / Enable HTTPS" : `disabled`
    * Web interface / advanced settings / Public Tautulli Domain : `http://web.mydomain.com` (usefull for newsletter and image - newsletter are exposed through mambo service `web`)


### Sabnzbd

* Folders 
    * Temporary Download Folder : `/download/incomplete`
    * Completed Download Folder : `/download/complete`
    * Watched Folder : `/vault/nzb`
    * Scripts Folder : `/scripts`

* Categories
    * Create a categorie for each kind of media and store media files in folder/path `/media/folders` as defined by variables `MAMBO_MEDIA_FOLDERS`


### Medusa

* Medusa configuration :
    * General / Misc
        * Show root directories : add each tv media folders from `/media/folders` as defined by variables `MAMBO_MEDIA_FOLDERS`

* Sabnzbd configuration :
    * Search settings/NZB Search
        * Enable nzb search providers
        * Send .nzb files : `SABnzbd`
        * SABnzbd server url : http://sabnzbd:8080
        * Set sabnzbd user/password and api key


* Plex configuration:
    * Notifications/Plex Media Server
        * get Auth token with `./mambo info plex`
        * set plex media server ip:port : `plex:32400`
        * HTTPS : `enabled`


### Ombi

* Guide https://github.com/Cloudbox/Cloudbox/wiki/Install%3A-Ombi

* Parameters 
    * Ombi / do not allow to collect analytics data
    * Configuration / User importer 
        * Import Plex Users : `enabled`
        * Import Plex Admin : `enabled`
        * Default Roles : Request Movie/TV
    * Configuration / Authentification
        * Enable plex OAuth : `enabled`
    * Media Server / Plex configuration / Add server
        * Server Name : free text
        * Hostname : `plex`
        * Port : `32400`
        * SSL : `enabled`
        * Plex Authorization Token : get Auth token with `./mambo info plex`
        * Click on Test Connectivity
        * Click on Load Libraries and select libraries in which content will look for user request

### JDownloader2

* set `JDOWNLOADER2_EMAIL` and `JDOWNLOADER2_PASSWORD` variables before launch
* you can see your instance at https://my.jdownloader.org/


### organizr2

* With organiz2, you could bring up a central portal for all your services

* Setup
    * License : personal
    * User : plex admin username, email and some other password
    * Hash : choose a keyword
    * registration password : choose a password so that user can signup themselves
    * db name : db
    * db path : /config/www/db

* Setup Theme
    * Settings / Customize / Appearance / Top bar : set title and description
    * Settings / Customize / Appearance / Login Page : pick login logo, wallpaper and minimal login screen
    * Settings / Customize / Marketplace : install plex theme
    * Settings / Customize / Appearance / Colors & Themes : select theme plex

* Add services - a sample for ombi service
    * Tab editor
        * Tab name : Ombi
        * Test tab : it will indicate if we can use this tab as iframe
        * Tab Url : http://ombi.mydomain.com

* NOTE :
    * `Local Tab URL` if not empty is used when organizr detect http request come from local network instead of value of `Tab URL` which is used when requesting from outside network (internet). But in **all cases** ORL in `Local Tab URL` or `Tab URL` must be reachable from the browser.
    * You should write reverse proxy rules to 
        * firstly reverse proxy the service because these URL which may not be reachable from outside network (internet)
        * secondly use organizr authorization API [https://docs.organizr.app/books/setup-features/page/serverauth]
        * lastly use organizr SSO by playing around http header with reverse proxy role [https://docs.organizr.app/books/setup-features/page/sso]
    * For writing specific reverse proxy rules for organizr nginx is more suitable than traefik2 because it can modify the response and inject some code like CSS for cutom thema with `sub_filter` instruction
        ```
        location /sonarr {
            proxy_pass http://192.168.1.34:8990/sonarr;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_redirect off;
            proxy_buffering off;
            proxy_http_version 1.1;
            proxy_no_cache $cookie_session;
            # modify CSS part
            proxy_set_header Accept-Encoding "";
            sub_filter
            '</head>'
            '<link rel="stylesheet" type="text/css" href="https://gilbn.github.io/theme.park/CSS/themes/sonarr/plex.css">
            </head>';
            sub_filter_once on;
        }
        ```
    
* Organizr authentification with Plex configuration [https://docs.organizr.app/books/setup-features/page/plex-authentication] :
    * Settings / System Settings / Main / Authentication
        * Type : Organizr DB + Backend
        * Backend : plex
        * Do get plex token / get plex machine
        * Admin username : a plex user admin that will match admin organir admin account
        * Strict plex friends : enabled
        * Enable Plex oAuth : enabled (active plex login to log into organizr)
    * Settings / System Settings / Main / Login
        * Hide registration : enabled - if you wish to disable auto registration

* NOTE : information on organizr Single Sign On integration with other services : https://docs.organizr.app/books/setup-features/page/sso



https://github.com/causefx/Organizr/issues/1240

## NETWORK CONFIGURATION

### Logical area

* Mambo have 3 logical areas. `main`, `secondary` and `admin`. Each of them have a HTTP entrypoint and a HTTPS entrypoint. 
* So you can separate each service on different area according to your needs by opening/closing your router settings

* By default
    * all services are on `main` area, so accessible throuh ports 80/443 (ie: http://ombi.mydomain.com)
    * traefik admin services are on `main` area, so accessible throuh ports 30443 (only, no HTTP for traefik admin) (ie: http://traefik.mydomain.com)

* A service can be declared into several logical area

### Available areas and entrypoints

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


## HTTP/HTTPS CONFIGURATION

### HTTPS redirection

* To enable/disable HTTPS only access to each service, declare them in `MAMBO_SERVICES_REDIRECT_HTTPS` variable. An autosigned certificate will be autogenerate
    * NOTE : some old plex client do not support HTTPS (like playstation 3) so plex might be exclude from this variable

* ie in user env file : 
    ```
    MAMBO_SERVICES_REDIRECT_HTTPS=traefik ombi organizr2
    ```

### Certificate with Let's encrypt

* Variable LETS_ENCRYPT control if let's encrypt (https://letsencrypt.org/) is enabled or disabled for certificate generation
    * `LETS_ENCRYPT=disable` (default value) will disable auto generation
    * `LETS_ENCRYPT=enable` will auto generate a certificate for each services declared in `LETS_ENCRYPT_SERVICES`. (All services by default)
    * `LETS_ENCRYPT=debug` will use the test server of letsencrypt to not reach rate limit (https://letsencrypt.org/fr/docs/rate-limits/)
    
### Let's encrypt and non default port for main area

* If you change the network ports of main area to other ports than 80/443, you have to use change the letsencrypt method from `HTTP Challenge` to `DNS Challenge`
    * By default Mambo uses the `HTTP Challenge` which *requires* port 80/443 to be opened (https://docs.traefik.io/user-guides/docker-compose/acme-http/). 
    * Otherwise you need to configure API to access to your DNS provider to set the `DNS Challenge` (https://docs.traefik.io/user-guides/docker-compose/acme-dns/)

* How-to : in your user conf file
    * Set `LETS_ENCRYPT_CHALLENGE` to `DNS`
    * Set `LETS_ENCRYPT_CHALLENGE_DNS_PROVIDER` with your provider name 
    * Add needed variables for your providers. Consult https://docs.traefik.io/https/acme/#providers for details

    ```
        LETS_ENCRYPT_CHALLENGE=DNS
        LETS_ENCRYPT_CHALLENGE_DNS_PROVIDER=ovh
        OVH_ENDPOINT=xxx
        OVH_APPLICATION_KEY=xxx
        OVH_APPLICATION_SECRET=xxx
        OVH_CONSUMER_KEY=xxx
    ```


## GPU


### Information

* To confirm your host kernel supports the Intel Quick Sync feature, the following command can be executed on the host `lspci -v -s $(lspci | grep VGA | cut -d" " -f 1)` which should output `Kernel driver in use: i915` 
* If your Docker host also has a dedicated graphics card, the video encoding acceleration of Intel Quick Sync Video may become unavailable when the GPU is in use. 
* If your computer has an NVIDIA GPU, please install the latest Latest NVIDIA drivers for Linux to make sure that Plex can use your NVIDIA graphics card for video encoding (only) when Intel Quick Sync Video becomes unavailable.

## MAMBO ADDONS


* declare addons

    * ie in user env file : 
        ```
        MAMBO_ADDONS=addon_name#version
        ```

* install addons
    ```
    ./mambo init addons
    ```



### nzbToMedia

* Use to connect medusa and sabnzbd
* https://github.com/clinton-hall/nzbToMedia

* sample

    ```
    MAMBO_ADDONS="nzbToMedia#12.1.04" ./mambo init addons
    ```

* configure sabnzbd
    * Folders/Scripts Folder : `/scripts/nzbToMedia`

* configure autoProcessMedia.cfg
    ```
    [General]
    force_clean = 1
    [SickBeard]
    #### autoProcessing for TV Series
    #### tv - category that gets called for post-processing with SB
    [[tv]]
        enabled = 1
        host = medusa
        port = 8081
        apikey = ***-medusa-api-key-***
        username = ***-medusa-username-***
        password = ***-medusa-password-***
        ###### ADVANCED USE - ONLY EDIT IF YOU KNOW WHAT YOU'RE DOING ######
        # Set this to minimum required size to consider a media file valid (in MB)
        minSize = 50
    
    [Nzb]
        ###### clientAgent - Supported clients: sabnzbd, nzbget
        clientAgent = sabnzbd
        ###### SabNZBD (You must edit this if you're using nzbToMedia.py with SabNZBD)
        sabnzbd_host = http://sabnzbd
        sabnzbd_port = 8080
        sabnzbd_apikey = ***-sabnzbd-api-key-***
        ###### Enter the default path to your default download directory (non-category downloads). this directory is protected by safe>
        default_downloadDirectory = /download/complete
    ```


## ADDING A SERVICE

* Steps for adding a `foo` service
    * in `docker-compose.yml` 
        * add a `foo` service
        * add a dependency on this service into `mambo` service
    * in `env.default`
        * add a variable `FOO_VERSION=latest`
        * add a variable `SERVICE_FOO=foo`
        * if this service needs to access all media folders, add it to `MAMBO_MEDIA_SERVICES`
        * choose to which logical areas by default this service will be attached `main`, `secondary`, `admin` and add it to `MAMBO_SERVICES_AREA_MAIN`,`MAMBO_SERVICES_AREA_SECONDARY` and `MAMBO_SERVICES_AREA_ADMIN`
        * if this service has subservices, declare subservices into `MAMBO_SUBSERVICES`
        * add a `FOO_DIRECT_ACCESS_PORT` empty variable
    * in `mambo`
        * add time management in `__set_time_all`
        * add `foo` in command line argument in `TARGET` choices

## SIDE NOTES

* I tried my best to stick to docker-compose file features and write less bash code. But very quickly I gave up, docker-compose files is very bad when dealing with conf and env var.
* I cannot use 3.x docker compose version, while `--runtime` or `--gpus` are not supported in docker compose format (https://github.com/docker/compose/issues/6691)

## LINKS

* Media distribution
    * cloudbox https://github.com/Cloudbox/Cloudbox - docker based - ansible config script for service and install guide for each service
    * cloudbox addon https://github.com/Cloudbox/Community
    * openflixr https://www.openflixr.com/ - full VM
    * autopirate - https://geek-cookbook.funkypenguin.co.nz/recipes/autopirate/ - docker based - use traefik1 + oauth2 proxy
    * a media stack on docker with traefik1 https://gist.github.com/anonymous/66ff223656174fd39c76d6075d6535fd

* Traefik2
    * Traefik1 forward auth and keycloak https://geek-cookbook.funkypenguin.co.nz/ha-docker-swarm/traefik-forward-auth/keycloak/
    * Traefik2 reverse proxy + reverse an external url : https://blog.eleven-labs.com/fr/utiliser-traefik-comme-reverse-proxy/
    * Traefik1 and oauth2 proxy https://geek-cookbook.funkypenguin.co.nz/reference/oauth_proxy/

* Organizr2
    * organizr2 and nginx : https://guydavis.github.io/2019/01/03/nginx_organizr_v2/
    * organizr2 + nginx (using subdomains or subdirectories) + letsencrypt https://technicalramblings.com/blog/how-to-setup-organizr-with-letsencrypt-on-unraid/
    * organizr + nginx samples for several services https://github.com/vertig0ne/organizr-ngxc/blob/master/ngxc.php

* Let's encrypt
    * challenge types : https://letsencrypt.org/fr/docs/challenge-types/

* Aria2 download utility aria2
    * https://aria2.github.io/ - support standard download method and bitorrent and metalink format
    * http://ariang.mayswind.net/ - frontend
    * https://github.com/lukasmrtvy/lsiobase-aria2-webui - docker image

* youtube-dl download online videos
    * HTML GUI for youtube-dl : https://github.com/Rudloff/alltube


* Plex 
    * guides https://plexguide.com/
    * install plugin webtool https://github.com/Cloudbox/Cloudbox/blob/master/roles/webtools-plugin/tasks
    * install traktv plugin https://github.com/Cloudbox/Cloudbox/tree/master/roles/trakttv-plugin/tasks
    * install some agent and scanner https://github.com/Cloudbox/Community/wiki/Plex-Scanners-and-Agents 

* Backup solutions
    * https://geek-cookbook.funkypenguin.co.nz/recipes/duplicity/
    * https://rclone.org/
    * https://github.com/restic/restic

* Graphics themas
    * https://github.com/Archmonger/Blackberry-Themes
    * https://github.com/gilbN/theme.park

* NVIDIA GPU    
    * NVIDIA GPU unlock non-pro cards : https://github.com/keylase/nvidia-patch

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
