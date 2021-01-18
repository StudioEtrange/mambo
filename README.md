# MAMBO - An opiniated docker based media stack - WIP - do not use YET

A central portal for all your media services.

* Based on organizr2
* SSO for all service using plex authentification
* Access level managed and centralized in organizr2 (dynamic synced between organizr2 and traefik2)
* Generate an ebook newsletter section into tautulli
* Highly based on traefik2 for internal routing
* Support nvidia transcoding for plex
* Support Let's encrypt for HTTPS certificate generation
* Configurable through env variables or env file


## Requirements

* bash 4
* git
* docker

If you want to use hardware transcode on nvidia gpu :

* nvidia-docker

NOTE : mambo will auto install all other required tools like docker-compose

## Services included

* Organizr2 - Media portal
* Plex - media center
* Ombi - user request content  
* Sabnzbd - newzgroup download
* Medusa - tv episodes search and subtitles management
* Tautulli - plex statistics and newsletter
* JDownloader2 - direct download manager
* Tranmission - torrent downloader
* Calibre Web - web ebook reader and library
* Calibre - ebook management
* MKVToolNix - Matroska tools with WebGUI - Video Editing (Remuxing - changing media container while keeping original source quality)


&nbsp;
# USAGE


## Quick usage

* Install

    ```
    git clone https://github.com/StudioEtrange/mambo
    cd mambo
    ./mambo install
    ```

* TODO TO BE COMPLETED

* Create a `mambo.env` file in your $HOME with
    ```
    PLEX_USER=no@no.com
    PLEX_PASSWORD=****
    TANGO_DOMAIN=mydomain.com
    ```

* For HTTPS access
    ```
    LETS_ENCRYPT_MAIL=no@no.com
    ```

* Init
    ```
    ./mambo init 
    ```

* Launch
    ```
    ./mambo up
    ```

* Stop all
    ```
    ./mambo down
    ```

## Available commands

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
## Configuration

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
# Services Administration

## Enable/disable

* To declare a service use list `TANGO_SERVICES_AVAILABLE`
* To disable a service, use variable list `TANGO_SERVICES_DISABLED`

* ie in user env file : 
    ```
    TANGO_SERVICES_AVAILABLE=website database
    TANGO_SERVICES_DISABLED=database
    ```

## Start/stop a service

* Launch a specific service

    ```
    ./mambo up <service>
    ```

* Stop a service

    ```
    ./mambo down <service>
    ```

----

# Services configuration

* You need to configure yourself each service. Mambo do only a few configurations on some services. 
* Keep in mind that each service reached other services with url like `http://<service>:<default service port>` (ie `http://ombi:5000`)

----
## Plex

* Guide https://github.com/Cloudbox/Cloudbox/wiki/Install%3A-Plex-Media-Server

* TODO continue


### Plex and Organizr2 

Into Organizr2

* Add a tab in Organizr2 menu
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
    * Tab Editor / Homepage Items / Plex (WARN : you should check every values you setted in every tab of this settings panel before save it)
        * Enable, Minimum Authentication : User
        * Connection / Url : http://plex:32400
        * Connection / Token : get token with command `./mambo info plex`
        * Connection / Machine : get machine identifier with command `./mambo info plex`
        * Personalize all viewing options - recommended : 
            * Active Streams / Enable, Minimum Authentication : User
            * Active Streams / User Info Enabled, Minimum Authentication : Co-Admin
            * Misc Options / Plex Tab Name : Plex (Name of your plex tab in setted in tab editor)
            * Misc Options / Url : `https://organizr2.mydomain.com/plex` (WARN: this is your portal special entrypoint for plex to put here !)
            * The Plex Tab Name and Plex Tab WAN URL are used to configure the homepage items to open up inside the Plex Tab you have setup



----
## Organizr2

* With organiz2, you could bring up a central portal for all your services

* github project https://github.com/causefx/Organizr/
* docker github project https://github.com/Organizr/docker-organizr
* a guide https://smarthomepursuits.com/install-organizr-v2-windows/
* api documentation : https://organizr2.mydomain.com/api/docs/

### Organizr2 configuration

* Initial Setup
    * License : personal
    * User : plex admin real username, plex admin real email and a different password
    * Hash : choose a random keyword
    * registration password : choose a password so that user can signup themselves
    * api : do not change
    * db name : db
    * db path : /config/www/db
    * In system settings, main, API : get API key and set `ORGANIZR2_API_TOKEN_PASSWORD` value in a mambo.env file


* Use plex authentification with organizr2 [https://docs.organizr.app/books/setup-features/page/plex-authentication] :
    * Settings / System Settings / Main / Authentication
        * Type : Organizr DB + Backend
        * Backend : plex
        * Do get plex token / then save
        * Do get plex machine (you can use command `./mambo info plex` to check some plex server info)
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


### Organizr2 : Adding a service

* To add a service into organizr2 add a new tab
    * `Local Tab URL`, if not empty, is used when requesting service from inside network (local network)
    * `Tab URL` is used when requesting service from outside network (internet) (and inside network too, if `Local Tab URL` is empty)
    * Note that in **all cases** URL in `Local Tab URL` or `Tab URL` must be reachable directly from a browser (from inside local network for `Local Tab URL` and from internet for `Tab URL`).

### Organizr2 : authentification/authorization system

* When enabled (`ORGANIZR2_AUTHORIZATION=ON`) access to a service depends on group access level. By default the access level is for a new tab `Co-Admin`
    * This allow to access to the service through Organizr2 UI
    * This allow to direct access to the service url is  blocked by adding a forwardAuth middleware (`service-auth@rest`) to traefik dynamicly.
    * There is a mapping between the organizr2 tab name and the service name. Tab name and service name (after `_` character if there is any) must be the same
        * service name : `ombi` organizr2 tab name : `ombi`
        * service name : `calibreweb_books` organizr2 tab name : `books`


----
## Tautulli

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
    * Web interface / advanced settings / Public Tautulli Domain : `http://web.mydomain.com` (usefull for newsletters and images - newsletters are exposed through mambo service `web`)

### Tautulli newsletter

* TODO : mail setup

* NOTE : To edit subject and message in default newsletter you can use theses variables https://github.com/Tautulli/Tautulli/blob/master/plexpy/common.py 
    ```
    Newsletter url : {newsletter_url} 
    ```



### Tautulli new users

* to add a new plex user just refresh user list
* edit user and check "Allow guest access"

### Tautulli and Organizr2 

Into Organizr2

* Add a tab in Organizr2 menu
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
## Sabnzbd

* Free and easy binary newsreader
* https://sabnzbd.org/

### Auto configuration

* Auto configuration steps :
    `./mambo init sabnzbd`
    `./mambo init nzbtomedia`

* Start service
    `./mambo up sabnzbd`

### Sabnzbd and Organizr2 

Into Sabnzbd

* Add a tab in Organizr2 menu
    * Tab editor / add a tab ("plus" button)
        * Tab name : Sabnzbd - MUST be same name as listed in `mambo services list` - ignore case
        * Tab Url : `https://sabnzbd.mydomain.com`
        * Local Url : not needed (or same as Tab Url)
        * Choose image : sabnzbd
        * Press 'Test tab' : it will indicate if we can use this tab as iframe
        * Press 'Add tab'
        * Refresh your browser page
    * Tab editor / Tabs list
        * Group : Co-Admin

### Manual configuration

go to sabnzbd through organizr

* Sabnzbd Config 
    * Servers
        * Add your newsgroup servers
    * Categories : Create categories for kind of media files in folder/path `/media/folders` as defined by variables `TANGO_ARTEFACT_FOLDERS`
        * tv / script : nzbToSickBeard.sh
    * Switches
        * enable Direct Unpack


### Third party tools

* SABconnect++ (chrome plugin)
    * SABnzbd URL : https://sabnzbd.domain.com
    * SABnzbd API Key : get API key with ./mambo info sabnzbd or from within sabnzbd admin panel by generating a QRCode


----
## Medusa

Into Medusa

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


### Medusa and Organizr2 

Into Organizr2

* Add a tab in Organizr2 menu
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
## Ombi

* Guide https://github.com/Cloudbox/Cloudbox/wiki/Install%3A-Ombi

* Parameters 
    * Ombi
        * base url : -leave empty-
        * do not allow to collect analytics data
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
    * Configuration / Customization
        * Application Name : Your App
        * Application URL : https://organizr2.domain.com/ (portail URL)
    * Notifications / Email
        * settings based on your mail provider, sample for mymail@gmail.com :
        * Enable SMTP Authentification
        * SMTP Host : smtp.gmail.com
        * SMTP port : 587
        * Email sender address : mymail@gmail.com
        * Admin email : mymail@gmail.com
        * Email sender name : My Name
        * Username : mymail@gmail.com
        * Password : xxxx
        

### Ombi new users

* To add users 
    * Parameters / Configuration / User importer : Run importer

### Ombi and Organizr2 

Into Organizr2

* Add a tab in Organizr2 menu
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
---
## MKVToolNix

* Check it works at `https://mkvtoolnix.domain.com`

### MKVToolNix and Organizr2 

Into Organizr2

* Add a tab in Organizr2 menu
    * Tab editor / add a tab ("plus" button)
        * Tab name : MKVToolNix - MUST be same name as listed in `mambo services list` - ignore case
        * Tab Url : `https://mkvtoolnix.mydomain.com`
        * Local Url : not needed (or same as Tab Url)
        * Image url : `https://img2.freepng.fr/20180609/ij/kisspng-matroska-mkvtoolnix-computer-software-5b1b5f16f14ec2.9703737815285204709884.jpg`
        * Press 'Test tab' : it will indicate if we can use this tab as iframe
        * Press 'Add tab'
        * Refresh your browser page
    * Tab editor / Tabs list
        * Group : Co-Admin



----
## JDownloader2

* create an account on https://my.jdownloader.org/ and install a browser extension
* set `JDOWNLOADER2_EMAIL` and `JDOWNLOADER2_PASSWORD` variables before launch
* you can see your instance at https://my.jdownloader.org/

----
## Lazylibrarian

access through https://lazylibrarian.domain.com

* Config / Processing
    * Folders / eBook Library Folder : `/calibredb/books`

### Lazylibrarian Web and Organizr2

Into Organizr2

* Add a tab in Organizr2 menu
    * Tab editor / add a tab ("plus" button)
        * Tab name : Lazylibrarian - MUST be same name as listed in `mambo services list` - ignore case
        * Tab Url : `https://lazylibrarian.mydomain.com`
        * Local Url : not needed (or same as Tab Url)
        * Choose image : `lazylibrarian`
        * Press 'Test tab' : it will indicate if we can use this tab as iframe
        * Press 'Add tab'
        * Refresh your browser page
    * Tab editor / Tabs list 
        * Group : Co-Admin
      

----
## transmission

* Direct UI Access through https://internal-transmission.mydomain.com
    * protected by organizr auth and will auto login with a transmission auth basic
* Third tools access through https://transmission.mydomain.com
* NOTE : when modify settings from webui, they are saved only when transmission is stopped

### Transmission and Organizr2 

Into mambo.env 
    
* set TRANSMISSION_USER and TRANSMISSION_PASSWORD

Into Organizr2
    
* Add a tab in Organizr2 menu
    * Tab editor / add a tab ("plus" button)
        * Tab name : Transmission - MUST be same name as listed in `mambo services list` - ignore case
        * Tab Url : `https://internal-transmission.mydomain.com`
        * Local Url : not needed (or same as Tab Url)
        * Choose image : `transmission`
        * Press 'Test tab' : it will indicate if we can use this tab as iframe
        * Press 'Add tab'
        * Refresh your browser page
    * Tab editor / Tabs list
        * Group : Co-Admin

* Integration to Homepage :
    * Tab Editor / Homepage Items / Transmission
        * Enable, Minimum Authentication : Co-Admin
        * Connection / Url : http://transmission:9091
        * Connection / User and password : fill with correct values

----
## Calibre Web for Books

Calibre-web will print ebooks registerd in calibre database. When configured, it can send to kindle a converted ebook. Each converted created file is updated with metadata from its metadata.opf file and added to calibre database

Into Calibre web `https://books.mydomain.com`

* First access :
    * Location of Calibre database : /books
    * Connexion : admin/admin123

* Admin / Users / admin user
    * Password : change password to anything you want
    * Mail/... : anything you want

* Admin / Users / Add New user
    * Username : same as your plex admin user
    * Password : change password to anything you want
    * Mail/... : anything you want
    * Admin User

* Admin / Configuration / Edit Basic Configuration
    * Feature Configuration : Enable Uploads
    * External binaries
        * Path to Calibre E-Book Converter : /pool/mambo/ebooks/ebook_convert_wrapper.sh
        * Calibre E-Book Converter Settings : ADD_CALIBREDB_AND_METADATA_FROM_OPF /usr/bin /books -v
        * Path to Kepubify E-Book Converter : /usr/bin/kepubify
        * Location of Unrar binary : /usr/bin/unrar

* Admin / Email server smtp settings
    * needed at least to get send to kindle feature
    * settings based on your mail provider, sample for mymail@gmail.com :
        * SMTP hostname : smtp.gmail.com
        * SMTP port : 465 (Calibre-web do not accept use of port 587 for SMTPS dont know why)
        * Encryption : SSL/TLS
        * SMTP login : mymail@gmail.com
        * SMTP Password: xxxx
        * From e-mail : My Name

* Admin / Configuration / Edit UI Configuration
    * Default Settings for New Users
        * Allow Downloads (needed to get send to kindle feature)
        * Allow eBook Viewer
    * View Configuration 
        * Title : choose a title
        * Theme : caliblur
        * sort regexp : tweak it if needed


### Calibre Web new users

To add a matching plex user to Calibre web, 
you can check registerd plex username/mail in Ombi user list

* Admin / Users / Add New user
    * Username : same as plex username
    * Password : anything you want
    * Mail : same as plex mail
    * Language : choose a language for UI


Each user can set himself it's kindle mail. Calibre-web convert on the fly the sent ebook as mobo format for kindle if necessary.

### Calibre Web and Organizr2

Into Organizr2

* Add a tab in Organizr2 menu
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

* Admin-Settings / Configuration / Edit Basic Configuration / Feature Configuration
    * Allow Reverse Proxy Authentication : enable
    * Reverse Proxy Header Name : `X-Organizr-User`

WARN

* with this system you cannot logout of calibreweb but only by logout from organizr2. And you can not to login as a different user into calibreweb for debug or test purpose
* to debug/test add a direct access port to calibre web dedicated to your media : `CALIBREWEB_BOOKS_DIRECT_ACCESS_PORT=22222` and access it through `http://localhost:22222`



# Calibre

Into Organizr2

    * Add a tab in Organizr2 menu
    * Tab editor / add a tab ("plus" button)
        * Tab name : Calibre - MUST be same name as listed in `mambo services list` - ignore case
        * Tab Url : `https://calibre.mydomain.com`
        * Local Url : not needed (or same as Tab Url)
        * Choose image : any image
        * Press 'Test tab' : it will indicate if we can use this tab as iframe
        * Press 'Add tab'
        * Refresh your browser page
    * Tab editor / Tabs list 
        * Group : Co-Admin

Into Calibre

    * recommended action to add to toolbar
        * "Embed Metadata" action (FR : "integrer metadonnees") - for any file format
        * "Polish book" action (FR : "polir livres") - for ePub and AZW3 files
    * recommended plugins
        * "Modify ePub" - for ePub files
        * "Quality check" - for ePub files
        * "Babelio" plugins - for babelio.com metadata https://www.mobileread.com/forums/showthread.php?t=294421

    * all calibre database are in folder `/calibredb`

----
# Network Configuration

* for more information see https://github.com/StudioEtrange/tango/blob/master/README.md

## Logical area

* Mambo use 2 logical areas. `main` and `admin`. Each of them have a HTTP entrypoint and a HTTPS entrypoint. 

* By default
    * all services are on `main` area, so accessible throuh ports 80/443 (ie: http://ombi.mydomain.com)
    * traefik admin services are on `admin` area, so accessible throuh ports 9000/9443 (ie: http://traefik.mydomain.com)


## Available areas and entrypoints

|logical area|entrypoint name|protocol|default port|variable|
|-|-|-|-|-|
|main|web_main|HTTP|80|NETWORK_PORT_MAIN|
|main|web_main_secure|HTTPS|443|NETWORK_PORT_MAIN_SECURE|
|admin|web_admin|HTTP|9000|NETWORK_PORT_ADMIN|
|admin|web_admin_secure|HTTPS|9443|NETWORK_PORT_ADMIN_SECURE|

----
## HTTP/HTTPS CONFIGURATION

HTTPS redirection

* By default HTTP to HTTPS auto redirection is active
* To enable/disable HTTPS only access to each service, declare them in `NETWORK_SERVICES_REDIRECT_HTTPS` variable. An autosigned certificate will be autogenerate
    * NOTE : some old plex client do not support HTTPS (like playstation 3) so plex might be excluded from this variable

* ie in user env file : 
    ```
    NETWORK_SERVICES_REDIRECT_HTTPS=traefik ombi organizr2
    ```

----
# Mambo Plugins

List of available plugins

## Transmission PIA port

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


## nzbToMedia - TODO not a plugin anymore

* Use to connect medusa and sabnzbd
* https://github.com/clinton-hall/nzbToMedia
