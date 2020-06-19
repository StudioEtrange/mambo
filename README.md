# MAMBO - A docker based media stack

CONTINUE HERE : faire une tache crontab qui requete organizr2 et fais des put sur traefik sur le lien forwardAuth

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
* Tranmission - torrent downloader
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
    TANGO_DOMAIN=mydomain.com
    ```

* For HTTPS only access, add 
    ```
    LETS_ENCRYPT=enable
    LETS_ENCRYPT_MAIL=no@no.com

    NETWORK_SERVICES_REDIRECT_HTTPS=traefik ombi sabnzbd tautulli medusa
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
    install : deploy this app.
    init [--claim] : init services. Do it once before launch. - will stop plex --claim : will force 	
	up [service [-b]] [--module module] [--plugin plugin] [--freeport]: launch all available services or one service
	down [service] [--mods mod-name] [--all]: down all services or one service. Except shared internal service when in shared mode (--all force stop shared service).
	restart [service] [--module module] [--plugin plugin] [--freeport]: restart all services or one service.
	info [--freeport] : give info. Will generate conf files and print configuration used when launching any service.
	status [service] : see service status.
	logs [service] : see service logs.
	update <service> : get last version of docker image service. Will stop service if it was running.
	shell <service> : launch a shell into a running service.
	modules|plugins list : list available modules or plugins. A module is a predefined service. A plugin is plug onto a service.
	plugins <exec-service> <service>|<exec> <plugin>: exec all plugin attached to a service OR exec a plugin into all serviced attached.

	cert <path> --domain=<domain> : generate self signed certificate for a domain into a current host folder.
```




## MAMBO CONFIGURATION

* You could set every mambo variables through a user environment file, shell environment variables and some from command line. 


* All existing variables are listed in `tango.default.env`

* Resolution priority order :
    * Command line variables
    * Shell environment variables
    * User environment file variables
    * Default configuration file variables
    * Default values from mambo itself




### Standard variables


|NAME|DESC|DEFAULT VALUE|SAMPLE VALUE|
|-|-|-|-|
|TANGO_DOMAIN|domain used to access mambo. It is a regexp. `.*` stands for any domain or host ip.|`.*`|`mydomain.com`|
|TANGO_USER_ID|unix user which will run services and acces to files.|current user : `id -u`|`1000`|
|TANGO_GROUP_ID|unix group which will run services and acces to files.|current group : `id -g`|`1000`|
|TANGO_ARTEFACT_FOLDERS|list of paths on host that contains media files. Relative path to mambo app path|-|`/mnt/MEDIA/MOVIES /mnt/MEDIA/TV_SHOWS`|
|APP_DATA_PATH|path on host for services conf and data files. Relative to mambo app path.|`./mambo/workspace/data`|`../data`|
|DOWNLOAD_PATH|path on host for downloaded files. Relative to mambo app path.|`./mambo/workspace/download`|`../download`|
|PLEX_USER|your plex account|-|`no@no.com`|
|PLEX_PASSWORD|your plex password|-|`mypassword`|

### Advanced variables

* see `tango.default.env` for detail

* TODO TO BE COMPLETED


### Using a user environment file

* You could create a user environment file (default name : `mambo.env`) to set any available variables and put it everywhere. By default it will be looked for from your home directory

    ```
    ./mambo -f mambo.env up
    ```

* By default, mambo will look for any existing user environment file into `$HOME/mambo.env`

* A user environment file syntax is liked docker-compose env file syntax. It is **NOT** a shell file. Values are not evaluated.


    ```
    NETWORK_PORT_MAIN=80
    APP_DATA_PATH=../mambo-data
    DOWNLOAD_PATH=../mambo-download
    TANGO_ARTEFACT_FOLDERS=/mnt/MEDIA/MOVIES /mnt/MEDIA/TV_SHOWS
    ```


### Using shell environment variables

* Set variables at mambo launch or export them before launch

    ```
    TANGO_DOMAIN="mydomain.com" APP_DATA_PATH="/home/$USER/mambo-data" ./mambo up
    ```


### For Your Information about env files - internal mechanisms


* At each launch mambo use `tango.default.env` file and your conf file (`mambo.env`) files to generate
    * `.env` file used by docker-compose
    * `bash.env` file used by mambo shell scripts


* You may know that a `.env` file is read by docker-compose by default to replace any variable present in docker-compose file anywhere in the file but NOT for define shell environment variable inside running container ! 


    ```
    test:
        image: bash:4.4.23
        command: >
            bash -c "echo from docker compose : $NETWORK_PORT_MAIN from running container env variable : $$NETWORK_PORT_MAIN"
    ```

    * This above only show NETWORK_PORT_MAIN value but $$NETWORK_PORT_MAIN (with double dollar to not have docker-compose replace the value) is empty unless you add this :

    ```
    test:
        image: bash:4.4.23
        env_file:
            - .env
        command: >
            bash -c "echo from docker compose : $NETWORK_PORT_MAIN from running container env variable : $$NETWORK_PORT_MAIN"
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

* NOTE : To edit subject and message in default newsletter you can use theses variables https://github.com/Tautulli/Tautulli/blob/master/plexpy/common.py 
    ```
    Newsletter url : {newsletter_url} 
    ```

### Sabnzbd

* Folders 
    * Temporary Download Folder : `/download/incomplete`
    * Completed Download Folder : `/download/complete`
    * Watched Folder : `/vault/nzb`
    * Scripts Folder : `/scripts`

* Categories
    * Create a categorie for each kind of media and store media files in folder/path `/media/folders` as defined by variables `TANGO_ARTEFACT_FOLDERS`


### Medusa

* Medusa configuration :
    * General / Misc
        * Show root directories : add each tv media folders from `/media/folders` as defined by variables `TANGO_ARTEFACT_FOLDERS`

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

* create an account on https://my.jdownloader.org/ and install a browser extension
* set `JDOWNLOADER2_EMAIL` and `JDOWNLOADER2_PASSWORD` variables before launch
* you can see your instance at https://my.jdownloader.org/

### transmission

* NOTE : settings are saved only when transmission is stopped

### organizr2

* With organiz2, you could bring up a central portal for all your services

* Initial Setup
    * License : personal
    * User : plex admin real username, plex admin email and a different password
    * Hash : choose a keyword
    * registration password : choose a password so that user can signup themselves
    * api : do not change
    * db name : db
    * db path : /config/www/db


* Add services - a sample for ombi service :
    * Tab editor - add a tab
        * Tab name : Ombi
        * Tab Url : http://ombi.mydomain.com
        * Choose ombi-plex image
        * Test tab : it will indicate if we can use this tab as iframe
        * Add tab
        * Refresh page

* NOTE :
    * `Local Tab URL` if not empty is used when requesting service from inside network (local network)
    * `Tab URL` is used when requesting service from outside network (internet). 
    * Note that in **all cases** URL in `Local Tab URL` or `Tab URL` must be reachable from a browser (from inside local network for `Local Tab URL` and from internet for `Tab URL`).
    * You may need to write reverse proxy rules to 
        * firstly reverse proxy the service because `Tab URL` may not be reachable from outside network (internet)
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
    * api documentation : https://organizr2.mydomain.com/api/docs/

* Organizr authentification with Plex configuration [https://docs.organizr.app/books/setup-features/page/plex-authentication] :
    * Settings / System Settings / Main / Authentication
        * Type : Organizr DB + Backend
        * Backend : plex
        * Do get plex token / get plex machine
        * Admin username : a plex user admin that will match admin organizr admin account
        * Strict plex friends : enabled
        * Enable Plex oAuth : enabled (active plex login to log into organizr)
    * Settings / System Settings / Main / Login
        * Hide registration : enabled - if you wish to disable auto registration


* Setup Theme
    * Settings / Customize / Appearance / Top bar : set title and description
    * Settings / Customize / Appearance / Login Page : 
        * use logo instead of Title on Login Page
        * wallpaper 
        * and minimal login screen
    * Settings / Customize / Marketplace : install plex theme
    * Settings / Customize / Appearance / Colors & Themes : select theme plex



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
|main|web_main|HTTP|80|NETWORK_PORT_MAIN|
|main|web_main_secure|HTTPS|443|NETWORK_PORT_MAIN_SECURE|
|secondary|web_secondary|HTTP|20000|NETWORK_PORT_SECONDARY|
|secondary|web_secondary_secure|HTTPS|20443|NETWORK_PORT_SECONDARY_SECURE|
|admin|web_admin|HTTP|30000|NETWORK_PORT_ADMIN|
|admin|web_admin_secure|HTTPS|30443|NETWORK_PORT_ADMIN_SECURE|

### Sample usage

* With these logical areas, you could setup different topology.

* Example : if `ombi` and `medusa` must be access only through `organirz2` split services on different logical area and open your router port only for `main` area (HTTP/HTTPS port)
    ```
    MAMBO_SERVICES_ENTRYPOINT_MAIN=organizr2
    MAMBO_SERVICES_ENTRYPOINT_SECONDARY=ombi medusa sabnzbd
    ```

### Direct access port for debugging purpose


* For debugging, you can declare a direct access HTTP port to the service without using traefik with variables `*_DIRECT_ACCESS_PORT`. The first port declared as exposed in docker-compose file is mapped to its value.

    * access directly throuh http://host:7777
    ```
    OMBI_DIRECT_ACCESS_PORT=7777
    ```


## HTTP/HTTPS CONFIGURATION

### HTTPS redirection

* To enable/disable HTTPS only access to each service, declare them in `NETWORK_SERVICES_REDIRECT_HTTPS` variable. An autosigned certificate will be autogenerate
    * NOTE : some old plex client do not support HTTPS (like playstation 3) so plex might be exclude from this variable

* ie in user env file : 
    ```
    NETWORK_SERVICES_REDIRECT_HTTPS=traefik ombi organizr2
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

## MAMBO PLUGINS

### Transmission PIA port

* Plugin name : transmission_pia_port

* sample

    ```
    # must stop vpn and transmission to remove containers
    ./mambo down <attached vpn>
    ./mambo down transmission
    ./mambo up transmission
    # wait for <attached vpn> docker container to be healthy
    ./mambo plugins exec-service transmission
    ```


### nzbToMedia

* Use to connect medusa and sabnzbd
* https://github.com/clinton-hall/nzbToMedia


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
    * in `tango.default.env`
        * add a variable `FOO_VERSION=latest`
        * add a variable `SERVICE_FOO=foo`
        * if this service needs to access all media folders, add it to `TANGO_ARTEFACT_SERVICES`
        * choose to which logical areas by default this service will be attached `main`, `secondary`, `admin` and add it to `NETWORK_SERVICES_AREA_MAIN`,`NETWORK_SERVICES_AREA_SECONDARY` and `NETWORK_SERVICES_AREA_ADMIN`
        * if this service has subservices, declare subservices into `TANGO_SUBSERVICES`
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


* Organizr2
    * organizr2 and nginx : https://guydavis.github.io/2019/01/03/nginx_organizr_v2/
    * organizr2 + nginx (using subdomains or subdirectories) + letsencrypt https://technicalramblings.com/blog/how-to-setup-organizr-with-letsencrypt-on-unraid/
    * organizr + nginx samples for several services https://github.com/vertig0ne/organizr-ngxc/blob/master/ngxc.php
    * automated organizr2 installation : https://github.com/causefx/Organizr/issues/1370
    * various 
        * https://docs.organizr.app/books/setup-features/page/serverauth
        * https://docs.organizr.app/books/setup-features/page/sso
        * https://guydavis.github.io/2019/01/03/nginx_organizr_v2/
        * https://github.com/vertig0ne/organizr-ngxc/blob/master/ngxc.php
        * https://github.com/causefx/Organizr/issues/1116
        * https://www.reddit.com/r/organizr/comments/axbo3r/organizr_authenticate_other_services_radarr/
        * https://www.reddit.com/r/organizr/
    CONTINUE HERE : * organizr2 and traefik auth : https://github.com/causefx/Organizr/issues/1240
    https://docs.organizr.app/books/setup-features/page/serverauth
    https://docs.organizr.app/books/setup-features/page/plex-authentication
https://docs.organizr.app/books/setup-features/page/serverauth#bkmrk-method-2%3A-using-oaut
https://media.chimere-harpie.org/api/?v1/user/list

    * information on organizr Single Sign On integration with other services : https://docs.organizr.app/books/setup-features/page/sso



* Aria2 download utility aria2
    * https://aria2.github.io/ - support standard download method and bitorrent and metalink format
    * http://ariang.mayswind.net/ - frontend
    * https://github.com/lukasmrtvy/lsiobase-aria2-webui - docker image

* youtube-dl download online videos
    * HTML GUI for youtube-dl : https://github.com/Rudloff/alltube

* filebot ansible role https://github.com/Cloudbox/Community/blob/master/roles/filebot/tasks/main.yml

* Plex 
    * guides https://plexguide.com/
    * install plugin webtool https://github.com/Cloudbox/Cloudbox/blob/master/roles/webtools-plugin/tasks
    * install traktv plugin https://github.com/Cloudbox/Cloudbox/tree/master/roles/trakttv-plugin/tasks
    * install some agent and scanner https://github.com/Cloudbox/Community/wiki/Plex-Scanners-and-Agents 
    * dashboard stat : https://github.com/Boerderij/Varken

* Backup solutions
    * https://geek-cookbook.funkypenguin.co.nz/recipes/duplicity/
    * https://rclone.org/
    * https://github.com/restic/restic

* Graphics themas
    * CSS changes to many popular web services https://github.com/Archmonger/Blackberry-Themes
    * A collection of themes/skins for your favorite apps 
        https://github.com/gilbN/theme.park

* Unmanic - Video files converter with web ui and scheduler https://github.com/Josh5/unmanic

* Torrent

    * opening ports 
        * For better download/upload torrent client should be an active node by opening its port. Else less client
        can connect directly to your torrent client. So you may need to open this port on your router. check with https://canyouseeme.org/
        * In case of using VPN, most VPN provider do not offer port forwarding and your torrent client may not be reacheable.
        * Having a good upload rate is usefull with private tracker with quota rules or test for direct connection capability.
        But for such private trackers the VPN may have limited benefit (?) as long as the transfer traffic itself is encrypted, only the members can see what you download and upload and in private trackers.
        https://superuser.com/a/1053429/486518
        https://dietpi.com/phpbb/viewtopic.php?p=17692#p17692
        * to check if your IP have been detected using torrent : https://iknowwhatyoudownload.com
        * PIA vpn provider provide port forwarding on some server : https://www.privateinternetaccess.com/helpdesk/kb/articles/can-i-use-port-forwarding-without-using-the-pia-client

    * transmission family
        * docker images with openvpn client
            * docker bundle transmission with openvpn client, stop transmission when openvpn down, dinamucly configure remote port for pia (private internet access) and perfectprivacy vpn providers (see https://github.com/haugene/docker-transmission-openvpn/blob/master/transmission/start.sh)
            https://github.com/haugene/docker-transmission-openvpn


    * rtorrent family
        * installation
            * install on debian for rutorrent, rtorrent  with configuration detail https://terminal28.com/how-to-install-and-configure-rutorrent-rtorrent-debian-9-stretch/
            * install ansible role for rutorrent, rtorrent with complete dynamic rtorrent configuration https://github.com/Cloudbox/Cloudbox/tree/master/roles/rutorrent

        * samples
            * docker-compose sample with transmission torrent client, traefik2 and dperson openvpn client
            https://www.reddit.com/r/docker/comments/daahlq/anybody_have_openvpn_any_torrent_client_and/
            * docker-compose sample with rutorrent and dperson openvpn client
            https://community.containo.us/t/rutorrent-is-not-displaying-correctly-after-adding-path-rule/1987

        * docker images
            * docker bundle rtorrent, flood (web ui) - from code source
            https://github.com/Wonderfall/docker-rtorrent-flood
            https://hub.docker.com/r/wonderfall/rtorrent-flood/dockerfile
            * docker bundle rtorrent, rutorrent (webui), flood (web ui), autodl-irssi - based on linuxserver distribution - plugins : logoff fileshare filemanager pausewebui mobile ratiocolor force_save_session showip
            https://github.com/romancin/rutorrent-flood-docker
            https://hub.docker.com/r/romancin/rutorrent-flood
            * docker bundle rtorrent from package, rutorrent from source
            https://github.com/linuxserver/docker-rutorrent
        
        * docker images with openvpn client
            * docker bundle rTorrent-ps (bitorrent client : rtorrent extended distribution), ruTorrent (web front end), autodl-irssi (scan irc and download torrent), openvpn client, Privoxy (web proxy allow unfiltered access to index sites)
            https://github.com/binhex/arch-rtorrentvpn
            * docker bundle rtorrent, flood (web ui), openvpn client - with detailed rtorrent configuration
            https://github.com/h1f0x/rtorrent-flood-openvpn



## TODO

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
