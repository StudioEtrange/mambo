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

NOTE : mambo will auto install all other required tools like docker-compose

## SERVICES INCLUDED

* Plex - media center
* Ombi - user request content  
* Sabnzbd - newzgroup download
* Medusa - tv episodes search and subtitles management
* Tautulli - plex statistics and newsletter
* JDownloader2 - direct download manager
* Tranmission - torrent downloader
* Organizr2
* Handbrake - Video Conversion (Transcoding and compression)
* MKVToolNix - Matroska tools with WebGUI - Video Editing (Remuxing - changing media container while keeping original source quality)


Non functionnal

* Booksonic - audio book streamer : problem with Single Sign On


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
    PLEX_USER="no@no.com" PLEX_PASSWORD="****" ./mambo init plex
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
	init plex [--claim] : init plex services. Do it once before launch for plex. - will stop plex --claim : will force to claim server even it is already registred (claim TODO NOT IMPLEMENTED).
	up [service [-b]] [--module module] [--plugin plugin] [--freeport]: launch all available services or one service.
	down [service] [--mods mod-name] [--all]: down all services or one service. Except shared internal service when in shared mode (--all force stop shared service).
	restart [service] [--module module] [--plugin plugin] [--freeport]: restart all services or one service. (same action than up & down)"
	info [--freeport] [-v] : give info. Will generate conf files and print configuration used when launching any service.
	status [service] : see service status.
	logs [service] [-f] : see service logs.
	update <service> : get last version of docker image service. Will stop service if it was running.
	shell <service> : launch a shell into a running service.
	services|modules|plugins|scripts list : list available modules or plugins. A module is a predefined service. A plugin is plug onto a service.
	plugins exec-service <service>|exec <plugin> : exec all plugin attached to a service OR exec a plugin into all serviced attached.
	scripts exec <script> : exec a script.
	o-- various commands :"
	cert <path> --domain=<domain> : generate self signed certificate for a domain into a current host folder.
    letsencrypt rm : delete generated letsencrypt cert.
    auth sync : sync authorization information between organizr2 and traefik.
    auth enable|disable : temporary enable|disable organizr2 until next up/down. To be permanent use ORGANIZR2_AUTHORIZATION variable"

```




----
## CONFIGURATION

* You could set every mambo variables through a user environment file, shell environment variables and some from command line. 


* All existing variables are listed in mambo root folder `mambo.env`

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

* see `mambo.env` for detail

* TODO TO BE COMPLETED


### Using a user environment file

* You could create a user environment file (default name : `mambo.env`) to set any available variables and put it in your `$HOME` or elsewhere. By default it will be looked for from your home directory

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

----
## SERVICES ADMINISTRATION

### Enable/disable

* To declare a service use list `TANGO_SERVICES_AVAILABLE`
* To disable a service, use variable list `TANGO_SERVICES_DISABLED`

* ie in user env file : 
    ```
    TANGO_SERVICES_AVAILABLE=website database
    TANGO_SERVICES_DISABLED=database
    ```

### Start/stop a service

* Launch a specific service

    ```
    ./mambo up <service>
    ```

* Stop a service

    ```
    ./mambo down <service>
    ```


## SERVICES CONFIGURATION

* You need to configure yourself each service. Mambo do only a few configurations on some services. 
* Keep in mind that each service reached other services with url like `http://<service>:<default service port>` (ie `http://ombi:5000`)

----
### Plex

* Guide https://github.com/Cloudbox/Cloudbox/wiki/Install%3A-Plex-Media-Server

* TODO continue


#### Plex and Organizr2 

    Into Organizr2

    * Add a Plex tab in Organizr2 menu
        * Tab editor / add a tab ("plus" button)
            * Tab name : Plex - MUST be same name as listed in `mambo services list` - ignore case
            * Tab Url : `https://plex.mydomain.com`
            * Local Url : not needed (or same as Tab Url)
            * Choose image : `ombi-plex`
            * Press 'Test tab' : it will indicate if we can use this tab as iframe
            * Press 'Add tab'
            * Refresh your browser page
        * Tab editor / Tabs list 
            * Group : User

    * SSO : Allow to login only to organizr2, plex login is automatic
        * See Organizr2 settings

    * Integration to Homepage :
        * Tab Editor / Homepage Items / Plex
            * Enable, Minimum Authentication : User
            * Connection / Url : http://plex:32400
            * Connection / Token : get token with command `./mambo info plex`
            * Connection / Machine : get machine identifier with command `./mambo info plex`
            * Personalize all viewing options - recommended : 
                * Active Streams / Enable, Minimum Authentication : User
                * Active Streams / User Info Enabled, Minimum Authentication : Co-Admin
                * Misc Options / Name : Plex
                * Misc Options / Url : `https://plex.mydomain.com`


----
### Organizr2

* With organiz2, you could bring up a central portal for all your services

* github project https://github.com/causefx/Organizr/
* docker github project https://github.com/Organizr/docker-organizr
* a guide https://smarthomepursuits.com/install-organizr-v2-windows/
* api documentation : https://organizr2.mydomain.com/api/docs/

#### Organizr2 configuration

* Initial Setup
    * License : personal
    * User : plex admin real username, plex admin email and a different password
    * Hash : choose a keyword
    * registration password : choose a password so that user can signup themselves
    * api : do not change
    * db name : db
    * db path : /config/www/db
    * In system settings, main, API : get API key and set `ORGANIZR2_API_TOKEN_PASSWORD` value in a mambo.env file


* Use plex authentification with organizr2 [https://docs.organizr.app/books/setup-features/page/plex-authentication] :
    * Settings / System Settings / Main / Authentication
        * Type : Organizr DB + Backend
        * Backend : plex
        * Do get plex token / get plex machine (you can use command `./mambo info plex` to check plex server info)
        * Admin username : a plex user admin that will match admin organizr admin account
        * Strict plex friends : enabled (only plex friends are registered)
        * Enable Plex oAuth : enabled (active plex login to log into organizr)

    * Settings / System Settings / Main / Login
        * Hide registration : enabled - if you wish to disable auto registration

    * Settings / System Settings / Main / Security
        * Enable Traefik Auth Redirect - When accessing directly to a service and using forwardAuth to test user access, will redirect on organizr login page if user is not logged. (Will throw HTTP 401 if this option is disabled)

    * Tab Editor / Tabs list 
        * Homepage : active
        * Homepage : Default tab


    * Setup Theme
        * Settings / Customize / Appearance / Top bar : set title and description
        * Settings / Customize / Appearance / Login Page : 
            * use logo instead of Title on Login Page : disabled
            * minimal login screen : enable
        * Settings / Customize / Marketplace : install plex theme
        * Settings / Customize / Appearance / Colors & Themes : select theme plex, style dark
            (Theme URL is https://github.com/Burry/Organizr-Plex-Theme)


#### Organizr2 : Adding a service

    * To add a service into organizr2 add a new tab
        * `Local Tab URL`, if not empty, is used when requesting service from inside network (local network)
        * `Tab URL` is used when requesting service from outside network (internet) (and inside network too, if `Local Tab URL` is empty)
        * Note that in **all cases** URL in `Local Tab URL` or `Tab URL` must be reachable directly from a browser (from inside local network for `Local Tab URL` and from internet for `Tab URL`).

#### Organizr2 : authentification/authorization system

    * When enabled (`ORGANIZR2_AUTHORIZATION=ON`) access to a service depends on group access level. By default the access level is for a new tab `Co-Admin`
        * This allow to access to the service through Organizr2 UI
        * This allow to direct access to the service url is  blocked by adding a forwardAuth middleware (`service-auth@rest`) to traefik dynamicly.
        * There is a mapping between the organizr2 tab name and the service name. Tab name and service name (after `_` character if there is any) must be the same
            * service name : `ombi` organizr2 tab name : `ombi
            * service name : `calibreweb_books` organizr2 tab name : `books`


#### Organizr2 : Info about reverse proxy -- You may want to write reverse proxy rules to 
        * firstly reverse proxy the service because `Tab URL` may not be reachable from outside network (internet)
        * secondly use organizr authorization API [https://docs.organizr.app/books/setup-features/page/serverauth]
        * lastly use organizr SSO by playing around http header with reverse proxy role [https://docs.organizr.app/books/setup-features/page/sso] [reverse proxy rule sample : https://github.com/vertig0ne/organizr-ngxc/blob/master/ngxc.php]
    * writing specific reverse proxy rules for organizr nginx is more suitable than traefik2 because it can modify the response and inject some code like CSS for cutom thema with `sub_filter` instruction
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
----
### Booksonic

* Initial Configuration
    * access to Booksonic - a 'getting started' page will appear
    * change default login password
    * Setup Media Folder : add a media folder. Shoud be one from `TANGO_ARTEFACT_FOLDERS` list, mounted under `/media/`

* Booksonic-App android reader
    * build from source 
        * https://amp.reddit.com/r/Booksonic/comments/hboaua/building_from_source/
        * instructions : https://github.com/mmguero-android/Booksonic-Android

#### Booksonic and Organizr2 

    Into Organizr2

    * Add a Booksonic tab in Organizr2 menu
        * Tab editor / add a tab ("plus" button)
            * Tab name : Tautulli - MUST be same name as listed in `mambo services list` - ignore case
            * Tab Url : `https://booksonic.mydomain.com`
            * Local Url : not needed (or same as Tab Url)
            * Choose image : booksonic
            * Press 'Test tab' : it will indicate if we can use this tab as iframe
            * Press 'Add tab'
            * Refresh your browser page
        * Tab editor / Tabs list
            * Group : User
            * Type : New Window

    * SSO : impossible to make it work
        * booksonic implement a version of subsonic API for HTTP request with password https://booksonic.chimere-harpie.org/rest/getStarred.view?u=USER&p=PASSWORD&v=1.14.0&c=CLIENTNAME and after this request it create a cookie and the user is authentificated. https://www.reddit.com/r/Booksonic/comments/emkizu/question_about_accessing_the_booksonic_api/?utm_source=share&utm_medium=web2x&context=3
        * can not find a way to auto login from orginzr2
        * There is also the problem to give access to the Booksonic-App android reader
        * sync plex authent by using ldap to plex
            * https://github.com/hjone72/LDAP-for-Plex
            * https://github.com/Starbix/docker-plex-ldap


----
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



#### Tautulli and Organizr2 

    Into Organizr2

    * Add an Tautulli tab in Organizr2 menu
        * Tab editor / add a tab ("plus" button)
            * Tab name : Tautulli - MUST be same name as listed in `mambo services list` - ignore case
            * Tab Url : `https://tautulli.mydomain.com`
            * Local Url : not needed (or same as Tab Url)
            * Choose image : tautulli
            * Press 'Test tab' : it will indicate if we can use this tab as iframe
            * Press 'Add tab'
            * Refresh your browser page
        * Tab editor / Tabs list
            * Group : User
            
    * SSO : Allow to login only to organizr2, tautulli login is automatic
        * System Settings - Single Sign-On
            * Tautulli Url : `http://tautulli:5000` (DO NOT CHANGE THIS : it is the local docker network url)
            * `Enable` SSO
    
    * Integration to Homepage :
        * Tab Editor / Homepage Items / Taututlli
            * Enable, Minimum Authentication : User
            * Connection / Url : http://tautulli:8181
            * Connection / API : get api key from tautulli
            * Personalize all viewing options

----
### Sabnzbd

* Folders 
    * Temporary Download Folder : `/download/incomplete`
    * Completed Download Folder : `/download/complete`
    * Watched Folder : `/vault/nzb`
    * Scripts Folder : `/scripts`

* Categories
    * Create a categorie for each kind of media and store media files in folder/path `/media/folders` as defined by variables `TANGO_ARTEFACT_FOLDERS`

----
### Medusa

* Medusa configuration :
    * General / Misc
        * Show root directories : add each tv media folders from `/media/folders` as defined by variables `TANGO_ARTEFACT_FOLDERS`

* Sabnzbd configuration :
    * Search settings/NZB Search
        * Enable nzb search providers
        * Send .nzb files : `SABnzbd`
        * SABnzbd server url : `http://sabnzbd:8080`
        * Set sabnzbd user/password and api key

* Plex configuration:
    * Notifications/Plex Media Server
        * get Auth token with `./mambo info plex`
        * set plex media server ip:port : `plex:32400`
        * HTTPS : `enabled`


#### Medusa and Organizr2 

    Into Organizr2


    * Add a Medusa tab in Organizr2 menu
        * Tab editor / add a tab ("plus" button)
            * Tab name : Medusa - MUST be same name as listed in `mambo services list` - ignore case
            * Tab Url : `https://medusa.mydomain.com`
            * Local Url : not needed (or same as Tab Url)
            * Choose image : medusa
            * Press 'Test tab' : it will indicate if we can use this tab as iframe
            * Press 'Add tab'
            * Refresh your browser page
        * Tab editor / Tabs list
            * Group : Co-Admin


    * Integration to Homepage :
        * Tab Editor / Homepage Items / Sickrage
            * Enable, Minimum Authentication : User
            * Connection / Url : http://medusa:8081
            * Connection / API : get api key from medusa
            * Personalize all viewing options - recommended : 
                *  Misc Options / Default view : week
                *  Misc Options / Items by day : 7


    Into Medusa, deactivate login because access is protected with organizr2
        * General / Interface / Web Interface / HTTP username : blank
        * General / Interface / Web Interface / HTTP password : blank

----
### Ombi

* Guide https://github.com/Cloudbox/Cloudbox/wiki/Install%3A-Ombi

* Parameters 
    * Ombi / do not allow to collect analytics data
    * Configuration / User importer 
        * Import Plex Users : `enabled`
        * Import Plex Admin : `enabled`
        * Default Roles : Request Movie/TV
    * Configuration / Authentification
        * Enable plex OAuth : `enabled` (Allow to use Plex credentials to login Ombi)
    * Media Server / Plex configuration / Add server
        * Server Name : free text
        * Hostname : `plex`
        * Port : `32400`
        * SSL : `enabled`
        * Plex Authorization Token : get Auth token with `./mambo info plex`
        * Click on Test Connectivity
        * Click on Load Libraries and select libraries in which content will look for user request

----
#### Ombi and Organizr2 

    Into Organizr2

    * Add an Ombi tab in Organizr2 menu
        * Tab editor / add a tab ("plus" button)
            * Tab name : Ombi - MUST be same name as listed in `mambo services list` - ignore case
            * Tab Url : `https://ombi.mydomain.com/auth/cookie`
            * Local Url : not needed (or same as Tab Url)
            * Choose image : `ombi-plex`
            * Press 'Test tab' : it will indicate if we can use this tab as iframe
            * Press 'Add tab'
            * Refresh your browser page
        * Tab editor / Tabs list 
            * Group : User

    * SSO : Allow to login only to organizr2, ombi login is automatic
        * System Settings - Single Sign-On
            * Ombi Url : `http://ombi:5000` (DO NOT CHANGE THIS : it is the local docker network url)
            * Token : get API Key from Ombi settings / Ombi / Ombi Configuration

    * Integration to Homepage : TODO

----
### JDownloader2

    * create an account on https://my.jdownloader.org/ and install a browser extension
    * set `JDOWNLOADER2_EMAIL` and `JDOWNLOADER2_PASSWORD` variables before launch
    * you can see your instance at https://my.jdownloader.org/

----
### transmission

    * NOTE : settings are saved only when transmission is stopped




----
### Calibre Web

    * Location of Calibre database : /books

    * Admin / Configuration / Edit UI Configuration
        * View Configuration / Theme : caliblur
    * Admin / Configuration / Edit Basic Configuration
        * Feature Configuration : Enable Uploads
        * External binaries
            * Path to Calibre E-Book Converter : /usr/bin/ebook-convert
            * Path to Kepubify E-Book Converter : /usr/bin/kepubify
            * Location of Unrar binary : /usr/bin/unrar

#### Calibre Web and Organizr2 
    Into Organizr2

    * Add an Ombi tab in Organizr2 menu
        * Tab editor / add a tab ("plus" button)
            * Tab name : books - MUST be same name as listed in `mambo services list` - ignore case
            * Tab Url : `https://books.mydomain.com`
            * Local Url : not needed (or same as Tab Url)
            * Choose image : `calibre-web`
            * Press 'Test tab' : it will indicate if we can use this tab as iframe
            * Press 'Add tab'
            * Refresh your browser page
        * Tab editor / Tabs list 
            * Group : User
            * Type : New window


    Into Calibre web

    <!-- * Admin / Configuration / Edit Basic Configuration / Feature Configuration
        * Allow Reverse Proxy Authentication : enable
        * Reverse Proxy Header Name :  -->

----
## NETWORK CONFIGURATION

* for more information see https://github.com/StudioEtrange/tango/blob/master/README.md

### Logical area

* Mambo have 3 logical areas. `main`, `secondary` and `admin`. Each of them have a HTTP entrypoint and a HTTPS entrypoint. 
* So you can separate each service on different area according to your needs by opening/closing your router settings

* By default
    * all services are on `main` area, so accessible throuh ports 80/443 (ie: http://ombi.mydomain.com)
    * traefik admin services are on `admin` area, so accessible throuh ports 9000/9443 (ie: http://traefik.mydomain.com)

* A service can be declared into several logical area

### Available areas and entrypoints

|logical area|entrypoint name|protocol|default port|variable|
|-|-|-|-|-|
|main|web_main|HTTP|80|NETWORK_PORT_MAIN|
|main|web_main_secure|HTTPS|443|NETWORK_PORT_MAIN_SECURE|
|secondary|web_secondary|HTTP|8000|NETWORK_PORT_SECONDARY|
|secondary|web_secondary_secure|HTTPS|8443|NETWORK_PORT_SECONDARY_SECURE|
|admin|web_admin|HTTP|9000|NETWORK_PORT_ADMIN|
|admin|web_admin_secure|HTTPS|9443|NETWORK_PORT_ADMIN_SECURE|


----
## HTTP/HTTPS CONFIGURATION

### HTTPS redirection

* By default HTTP to HTTPS auto redirection is active
* To enable/disable HTTPS only access to each service, declare them in `NETWORK_SERVICES_REDIRECT_HTTPS` variable. An autosigned certificate will be autogenerate
    * NOTE : some old plex client do not support HTTPS (like playstation 3) so plex might be excluded from this variable

* ie in user env file : 
    ```
    NETWORK_SERVICES_REDIRECT_HTTPS=traefik ombi organizr2
    ```

----
## MAMBO PLUGINS

List of available plugins

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

----
## ADDING A SERVICE

* Steps for adding a `foo` service
    * in `docker-compose.yml` 
        * add a `foo` service block
        * add a dependency on this service into `mambo` service
    * in `mambo.env`
        * add a variable `FOO_VERSION=latest`
        * add service to `TANGO_SERVICES_AVAILABLE` list
        * if this service has subservices, declare subservices into `TANGO_SUBSERVICES_ROUTER`
        * if this service needs to access all media folders, add it to `TANGO_ARTEFACT_SERVICES`
        * choose to which logical network areas by default this service will be attached `main`, `secondary`, `admin` and add it to `NETWORK_SERVICES_AREA_MAIN`,`NETWORK_SERVICES_AREA_SECONDARY` and `NETWORK_SERVICES_AREA_ADMIN`
        * to generate an HTTPS certificate add service to `LETS_ENCRYPT_SERVICES`
        * if HTTPS redirection add service to `NETWORK_SERVICES_REDIRECT_HTTPS`
        * for time setting add service to TANGO_TIME_VOLUME_SERVICES or `TANGO_TIME_VAR_TZ_SERVICES`
    * in `mambo`
        * add `foo` in command line argument definition of `TARGET` choices
    * in README.md
        * add a section to describe its configuration

----
## LINKS

* Media distribution
    * cloudbox https://github.com/Cloudbox/Cloudbox - docker based - ansible config script for service and install guide for each service
    * cloudbox addon https://github.com/Cloudbox/Community
    * openflixr https://www.openflixr.com/ - full VM
    * autopirate - https://geek-cookbook.funkypenguin.co.nz/recipes/autopirate/ - docker based - use traefik1 + oauth2 proxy
    * a media stack on docker with traefik1 https://gist.github.com/anonymous/66ff223656174fd39c76d6075d6535fd
    * another media stack : https://gitlab.com/guillaumedsde/docker-media-stack/-/tree/master

* Organizr2
    * organizr2 and nginx : https://guydavis.github.io/2019/01/03/nginx_organizr_v2/
    * organizr2 + nginx (using subdomains or subdirectories) + letsencrypt https://technicalramblings.com/blog/how-to-setup-organizr-with-letsencrypt-on-unraid/
    * organizr + nginx samples for several services https://github.com/vertig0ne/organizr-ngxc/blob/master/ngxc.php
    * automated organizr2 installation : https://github.com/causefx/Organizr/issues/1370
    * various
        * https://guydavis.github.io/2019/01/03/nginx_organizr_v2/
        * https://www.reddit.com/r/organizr/comments/axbo3r/organizr_authenticate_other_services_radarr/
    * STILL NOT FULLY WORK organizr2 and traefik2 auth : 
        https://github.com/causefx/Organizr/issues/1240
        https://docs.organizr.app/books/setup-features/page/serverauth
    * Plex Auth https://github.com/hjone72/PlexAuth



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

* Komga - comics server

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


