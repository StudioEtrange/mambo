# MAMBO - An opiniated docker based media stack - WIP - do not use YET

* WIP - do not use YET*
A central portal for all your media content movies, tv show, ebooks

## Features

* Based on organizr2
* SSO for all service using plex authentification
* Access level managed and centralized in organizr2 (dynamic synced between organizr2 and traefik2)
* Generate an ebook newsletter section into tautulli newsletter
* Add newsletter functionnality for ebooks
* API access to sabnzbd
* Highly based on traefik2 for internal routing
* Support nvidia transcoding for plex
* Support Let's encrypt for HTTPS certificate generation
* Configurable through env variables or env file


## Requirements

* bash 4
* git
* docker


NOTE : mambo will auto install all other required tools like docker-compose inside of its tree folder

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
* Kindle Comic Converter - graphical tool and cli to manage/convert  ebook


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

### 1.Auto configuration

* Auto configuration steps :
    `./mambo init plex`

* Start service
    `./mambo up plex`

### 2.Plex and Organizr2 

Into Organizr2

* Add a tab in Organizr2 menu
    * Tab editor / add a tab ("plus" button)
        * Tab name : Plex - MUST be same name as listed in `mambo services list` - ignore case
        * Tab Url : `https://plex.mydomain.com`
        * Choose image : `plex`
    * Tab editor / Tabs list 
        * Group : User

* SSO : Delegate ombi authentification to organizr2
    * See Organizr2 settings

* Integration to Homepage :
    * Tab Editor / Homepage Items / Plex (WARN : you should check every values you setted in every tab of this settings panel before save it)
        * Enable, Minimum Authentication : User
        * Connection / Url : http://plex:32400
        * Connection / Token : get token (X-Plex-Token) with command `./mambo info plex`
        * Connection / Machine : get machine identifier with command `./mambo info plex`
        * Personalize all viewing options - recommended : 
            * Active Streams / Enable, Minimum Authentication : User
            * Active Streams / User Info Enabled, Minimum Authentication : Co-Admin
            * Misc Options / Plex Tab Name : Plex (Name of your plex tab in setted in tab editor)
            * Misc Options / Url : `https://organizr2.mydomain.com/plex` (WARN: this is your portal special entrypoint for plex to put here !)

### Plex and GPU

* First, you will need nvidia-docker2 or nvidia-container-toolkit depending on your docker version
* To enable GPU transcoding into plex declare `PLEX_GPU=INTEL_QUICKSYNC|NVIDIA`


----
## Organizr2

* With organiz2, you could bring up a central portal for all your services

* source code : https://github.com/causefx/Organizr/
* docker image code : https://github.com/Organizr/docker-organizr
* a guide https://smarthomepursuits.com/install-organizr-v2-windows/
* api documentation : https://organizr.mydomain.com/api/docs/


### 1.Auto configuration

* Auto configuration steps :
    `./mambo init organizr2`

* Start service
    `./mambo up organizr2`

### 2.Manual configuration

go to https://organizr.domain.com (check ORGANIZR2_SUBDOMAIN value)

* Initial Setup
    * License : personal
    * User : plex admin real username, plex admin real email and a different password
    * Hash : choose a random keyword
    * registration password : choose a password so that user can signup themselves
    * api : do not change
    * db name : db
    * db path : /config/www/db
    
Into mambo.env
    * set key `ORGANIZR2_API_TOKEN_PASSWORD` with value from system Settings / System Settings / main / API

* To use plex authentification with organizr2 [https://docs.organizr.app/books/setup-features/page/plex-authentication] :
    * Settings / System Settings / Main / Authentication
        * Type : Organizr DB + Backend
        * Backend : plex
        * Do get plex token / then [SAVE]
        * Do get plex machine  / then [SAVE]
            * you can use command `./mambo info plex` to check some plex server info but only if you have already configured plex service
        * Admin username : a plex user admin that will match admin organizr admin account
        * Strict plex friends : enabled (only plex friends are registered)
        * Enable Plex oAuth : enabled (active plex login to log into organizr)

    * Settings / System Settings / Main / Login
        * Hide registration : enabled

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
        * Settings / Customize / Appearance / Options :  Disable useless lings
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


### Organizr2 : test another version

* To test another version, referenced by its commit, tag or github branch, there is an inactive service `organizrtest` for this purpose
    * Stop organizr main instance `./mambo down organizr2` and backup its data folder `mambo-data/oprganizr2`
    * Add this section into your `mambo.env`
    ```
    ORGANIZR2_INSTANCE=organizrtest
    ORGANIZR2_API_VERSION=2
    TANGO_SERVICES_AVAILABLE+=organizrtest
    TANGO_SUBSERVICES_ROUTER+=organizrtest_plex
    NETWORK_SERVICES_AREA_MAIN+=organizrtest
    NETWORK_SERVICES_REDIRECT_HTTPS+=organizrtest
    LETS_ENCRYPT_SERVICES+=organizrtest
    TANGO_TIME_VOLUME_SERVICES+=organizrtest
    ORGANIZRTEST_API_TOKEN_PASSWORD=
    APP_DATA_PATH_SUBPATH_LIST+=ORGANIZRTEST_DATA_PATH
    ORGANIZRTEST_BRANCH=manual
    ORGANIZRTEST_COMMIT=12357eeb0df0f97f8cc48de9208695fdd0b42e15
    ORGANIZRTEST_SUBDOMAIN=organizrtest.
    ORGANIZRTEST_DATA_PATH=organizrtest
    ```
    * Init & start test instance
    ```
    ./mambo init organizr2
    ./mambo up organizrtest
    ```
    * see https://organizrtest.domain.com
    * follow previous organizr2 configuration procedure

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
    * Web interface / advanced settings / Public Tautulli Domain : `https://web.mydomain.com` (usefull for newsletters and images - newsletters are exposed through mambo service `web`)

### Tautulli newsletter

* TODO : mail setup

* Settings / Notifications & Newsletters / Show Advanced
* Settings / Notifications & Newsletters / Newsletters
    * Self-Hosted Newsletters : checked
    * Use Inline Styles Templates : checked
    * Newsletter Output Directory : `/newsletters`
    * Custom newsletter Templates Folder : set value `/default_template`
        * if you want to customize the default newsletter template : set value folder as `/custom_template/templates` and edit in your data folder `ebooks_list/recently_added.mtml` following `mambo/ebooks/recently_added.html` (the default one) as guide. And
        * if you want a real preview of your newsletter with your custom template use : `https://tautulli.domain.com/real_newsletter?newsletter_id=1&preview=true` instead of this proposed url `https://tautulli.domain.com/newsletter_preview?newsletter_id=1`

* TIPS : Inside newsletter configuration; to edit subject and message in default newsletter you can use theses variables https://github.com/Tautulli/Tautulli/blob/master/plexpy/common.py 
    ```
    Newsletter url : {newsletter_url} 
    ```




### Tautulli new users

* to add a new plex user just refresh user list
* edit user and check "Allow guest access"

* more info : `./mambo info tautulli`

### Tautulli and Organizr2 

Into Organizr2

* Add a tab in Organizr2 menu
    * Tab editor / add a tab ("plus" button)
        * Tab name : Tautulli - MUST be same name as listed in `mambo services list` - ignore case
        * Tab Url : `https://tautulli.mydomain.com`
        * Choose image : tautulli
    * Tab editor / Tabs list
        * Group : User
        
* SSO : Allow to login only to organizr2, tautulli login is automatic
    * System Settings / Single Sign-On / Tautulli
        * Tautulli Url : `http://tautulli:8181` (DO NOT CHANGE THIS : it is the local docker network url)
        * `Enable` SSO

* Integration to Homepage :
    * Tab Editor / Homepage Items / Taututlli
        * Enable, Minimum Authentication : User
        * Personalize all viewing options
        * Connection / Url : http://tautulli:8181
        * Connection / API : get api key from tautulli or from `./mambo info tautulli`
        

----
## Sabnzbd

* Free and easy binary newsreader
* https://sabnzbd.org/

### 1.Auto configuration

* Auto configuration steps :
    `./mambo init sabnzbd`
    `./mambo init nzbtomedia`

* Start service
    `./mambo up sabnzbd`

### 2.Sabnzbd and Organizr2 

Into Organizr2

* Add a tab in Organizr2 menu
    * Tab editor / add a tab ("plus" button)
        * Tab name : Sabnzbd - MUST be same name as listed in `mambo services list` - ignore case
        * Tab Url : `https://sabnzbd.mydomain.com`
        * Choose image : sabnzbd
    * Tab editor / Tabs list
        * Group : Co-Admin


* Integration to Homepage :
    * Tab Editor / Homepage Items / sabnzbd
        * Check Enable
        * Minimum Authentication : Co-Admin
        * Connection / Url : http://sabnzbd:8080
        * Connection / Token : get API key with `./mambo info sabnzbd` or from within sabnzbd admin panel (you can get also from here a QRCode)
        

### 3.Manual configuration

go to sabnzbd through organizr https://organizr.mydomain.com/#Sabnzbd

* Sabnzbd Config 
    * Servers
        * Add your newsgroup servers
    * Categories : Create categories for each kind of media files in `/media/folders` as defined by variables `TANGO_ARTEFACT_FOLDERS`
        * tv / script : nzbToSickBeard.sh
    * Switches
        * enable Direct Unpack


### Third party tools

* SABconnect++ (chrome plugin)
    * SABnzbd URL : https://sabnzbd.domain.com
    * SABnzbd API Key : get API key with `./mambo info sabnzbd` or from within sabnzbd admin panel (you can get also from here a QRCode)

* SabNzbd Remote 2.0 (android app)
    * URL : sabnzbd.domain.com
    * Port: 443
    * Use SSL
    * Authentification Method : use api key
    * API Key : get API key with `./mambo info sabnzbd` or from within sabnzbd admin panel (you can get also from here a QRCode)


----
## Kindle Comic Converter (KCC)

* Kindle Comic Converter is a Python app to convert comic/manga files or folders to EPUB, Panel View MOBI or E-Ink optimized CBZ.
* source code : https://github.com/StudioEtrange/kcc
* docker image code : https://github.com/StudioEtrange/docker-kcc


### 1.Manual Configuration

* Start service
    `./mambo up kcc`



### 2.Manual configuration : KCC and Organizr2 

Into Organizr2

    
    * Image manager
        * Add image file `KCC_logo.png` from https://github.com/StudioEtrange/mambo/tree/master/pool/artefacts/img


    * Add a tab in Organizr2 menu
        * Tab editor / add a tab ("plus" button)
            * Tab name : KCC - MUST be same name as listed in `mambo services list` - ignore case
            * Tab Url : `https://kcc.mydomain.com`
            * Choose image : KCC_logo.png
        * Tab editor / Tabs list 
            * Group : Co-Admin


----
## Medusa


### 1.Auto configuration

* Auto configuration steps :
    `./mambo init medusa`
        * will set plex notification
        * will set sabnzbd as search provider
    `./mambo init nzbtomedia`
* Start service
    `./mambo up medusa`



### 2.Medusa and Organizr2 

Into Organizr2

* Add a tab in Organizr2 menu
    * Tab editor / add a tab ("plus" button)
        * Tab name : Medusa - MUST be same name as listed in `mambo services list` - ignore case
        * Tab Url : `https://medusa.mydomain.com`
        * Choose image : medusa
    * Tab editor / Tabs list
        * Group : Co-Admin


* Integration to Homepage :
    * Tab Editor / Homepage Items / Sickrage
        * Enable, Minimum Authentication : User
        * Connection / Url : http://medusa:8081
        * Connection / API : get api key from medusa (./mambo info medusa)
        * Personalize all viewing options - recommended : 
            *  Misc Options / Default view : week
            *  Misc Options / Items by day : 7


Into Medusa, deactivate login because access is protected with organizr2
    * General / Interface / Web Interface / HTTP username : blank
    * General / Interface / Web Interface / HTTP password : blank

### 3.Manual configuration

TODO


---

## nzbToMedia

* Special tool used to connect medusa and sabnzbd
* https://github.com/clinton-hall/nzbToMedia

* Usage
    * Only init it after init of sabnzbd and medusa with  `./mambo init nzbtomedia`

----
## Ombi

* Guide https://github.com/Cloudbox/Cloudbox/wiki/Install%3A-Ombi

## 1. Manual Configuration

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
        * Plex Authorization Token (X-Plex-Token) : get Auth token with `./mambo info plex`
        * Click on Test Connectivity
        * Click on Load Libraries and select libraries in which content will look for user request
    * Configuration / Customization
        * Application Name : Your App
        * Application URL : https://organizr.domain.com/ (portail URL)
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
        

### 2. Ombi and Organizr2 

Into Organizr2

* Add a tab in Organizr2 menu
    * Tab editor / add a tab ("plus" button)
        * Tab name : Ombi - MUST be same name as listed in `mambo services list` - ignore case
        * Tab Url : `https://ombi.mydomain.com/auth/cookie`
        * Choose image : `ombi-plex`
    * Tab editor / Tabs list 
        * Group : User

* SSO : Delegate ombi authentification to organizr2
    * System Settings - Single Sign-On
        * Ombi Url : `http://ombi:5000`
        * Token : get API Key from Ombi settings / Ombi / Ombi Configuration

* Integration to Homepage : TODO ?

### Ombi new users

* To add users 
    * Parameters / Configuration / User importer : Run importer

---
## MKVToolNix

* direct url : `https://mkvtoolnix.domain.com`

### 1.Manual Configuration

* Start service
    `./mambo up mkvtoolnix`



### 2.MKVToolNix and Organizr2 

Into Organizr2

* Image manager
    * Add image file `mkvtoolnix_logo.png` from https://github.com/StudioEtrange/mambo/tree/master/pool/artefacts/img

* Add a tab in Organizr2 menu
    * Tab editor / add a tab ("plus" button)
        * Tab name : MKVToolNix - MUST be same name as listed in `mambo services list` - ignore case
        * Tab Url : `https://mkvtoolnix.mydomain.com`
        * Choose image : `mkvtoolsnix_logo`
    * Tab editor / Tabs list
        * Group : Co-Admin



----
## JDownloader2

* create an account on https://my.jdownloader.org/ and install a browser extension
* set `JDOWNLOADER2_EMAIL` and `JDOWNLOADER2_PASSWORD` variables before launch
* you can see your instance at https://my.jdownloader.org/

----
## Lazylibrarian - WIP - Disabled

access through https://lazylibrarian.domain.com

### 1. Manual Configuration

* Config / Processing
    * Folders / eBook Library Folder : `/calibredb/books`
    * Filename formatting
        * Magazine Foldername Pattern : `/calibredb/press/$Title`
        * Magazine Filename Pattern: `$Title - $IssueDate`
        * Uncheck Magazines inside book folder


### 2.Lazylibrarian and Organizr2

Into Organizr2

* Add a tab in Organizr2 menu
    * Tab editor / add a tab ("plus" button)
        * Tab name : Lazylibrarian - MUST be same name as listed in `mambo services list` - ignore case
        * Tab Url : `https://lazylibrarian.mydomain.com`
        * Choose image : `lazylibrarian`
    * Tab editor / Tabs list 
        * Group : Co-Admin
      

----
## Transmission

* Direct UI Access through https://internal-transmission.mydomain.com
    * protected by organizr auth and will auto login with a transmission auth basic
* Third tools access through https://transmission.mydomain.com using credentials defined by `TRANSMISSION_USER` and `TRANSMISSION_PASSWORD`
* P2P network traeffik use port defined by `TRANSMISSION_PORT` env var

* vpn
    * you may want to attach this service to a vpn, if so see VPN section and if you have PIA provider the plugin Transmission PIA port
    * Test P2P traffic really use VPN : 
        * http://checkmyip.torrentprivacy.com/
        * http://ipmagnet.services.cbcdn.com/
    * when transmission is attached to a VPN all port declaration in compose-file are removed, TRANSMISSION_PORT env var is not used anymore



* NOTE : when modify settings from webui, they are saved only when transmission is stopped

### 1.Manual Configuration

Into mambo.env 
    * set TRANSMISSION_USER and TRANSMISSION_PASSWORD

* Start service
    `./mambo up transmission`

### 2.Transmission and Organizr2

Into Organizr2
    
* Add a tab in Organizr2 menu
    * Tab editor / add a tab ("plus" button)
        * Tab name : Transmission - MUST be same name as listed in `mambo services list` - ignore case
        * Tab Url : `https://internal-transmission.mydomain.com`
        * Choose image : `transmission`
    * Tab editor / Tabs list
        * Group : Co-Admin

* Integration to Homepage :
    * Tab Editor / Homepage Items / Transmission
        * Enable, Minimum Authentication : Co-Admin
        * Connection / Url : `https://transmission.mydomain.com/transmission/rpc/` (We can not use internal network alias http://transmission if transmission is tied to a vpn service)
        * Connection / User and password : fill with correct values from TRANSMISSION_USER and TRANSMISSION_PASSWORD


### Third party tools

* Transmission Easy Client 
    * https://chrome.google.com/webstore/detail/transmission-easy-client/cmkphjiphbjkffbcbnjiaidnjhahnned
    * user/pass : use `TRANSMISSION_USER` and `TRANSMISSION_PASSWORD` values
    * IP : transmission.mydomain.com
    * Port 443
    * Auth required
    * WebUI : /transmission/web
    * Use SSL
    * Path : /transmission/rpc
----
## Calibre Web for books


Calibre-web will print ebooks registerd in calibre database. When configured, it can send to kindle a converted ebook. Each converted created file is updated with metadata from its metadata.opf file and added to calibre database

About sending to kindle and format :
    * https://github.com/janeczku/calibre-web/blob/34a474101fa2b3dd97046f5febc84cb10ac9c27b/cps/helper.py#L211
    * If Mobi file is existing, it's directly send to kindle email,
    * If Epub file is existing, it's converted and send to kindle email,
    * If Pdf file is existing, it's directly send to kindle email

### 1.Manual Configuration

* Start service
    `./mambo up calibreweb_books`


Into Calibre web `https://books.mydomain.com`

* First access :
    * Location of Calibre database : /books
    * Connexion : admin/admin123

* Admin / Configuration / Edit UI Configuration
    * Default Settings for New Users
        * Allow Downloads (needed by the feature : send to kindle)
        * Allow eBook Viewer
    * Remove view by author and publisher
 
* Admin / Users / Add New user
    * Username : same as your plex admin user
    * Password : change password to anything you want
    * Mail/... : anything you want
    * Admin User

* Admin / Users / 
    * Select admin user
        * Password : change password to anything you want
        * Mail/... : anything you want

* Admin / Configuration / Edit Basic Configuration
    * Feature Configuration : Enable Uploads
    * External binaries
        * Path to Calibre E-Book Converter : /pool/mambo/ebooks/ebook_convert_wrapper.sh      
        * Calibre E-Book Converter Settings : METADATA_FROM_OPF /usr/bin /books -v 
            * for calibre-web < v0.6.11 which fo not auto add the converted book to calibre library : Calibre E-Book Converter Settings : ADD_CALIBREDB_AND_METADATA_FROM_OPF /usr/bin /books -v
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
    * View Configuration 
        * Title : choose a title
        * Theme : caliblur
        * sort regexp : tweak it if needed

### 2.Calibre Web and Organizr2

Into Organizr2

    * Image manager
        * Add image file `press_logo.png` from https://github.com/StudioEtrange/mambo/tree/master/pool/artefacts/img

Into Calibre web

* Admin-Settings / Configuration / Edit Basic Configuration / Feature Configuration
    * Allow Reverse Proxy Authentication : enable
    * Reverse Proxy Header Name : `X-Organizr-User`

Into Organizr2

* Add a tab in Organizr2 menu
    * Tab editor / add a tab ("plus" button)
        * Tab name : books - MUST be same name as listed in `mambo services list` (after character _) - ignore case
        * Tab Url : `https://books.mydomain.com`
        * Choose image : `calibre-web`
    * Tab editor / Tabs list 
        * Group : User


* Settings / System Settings / Main / Security
    * Iframe sandbox : add `Allow Downloads` to authorize ebooks downloading from within organizr window

WARN

* when setting is done, you cannot logout of calibreweb but only by logout from organizr2. And you can not to login as a different user into calibreweb for debug or test purpose
* to debug/test add a direct access port to calibreweb dedicated to your media : `CALIBREWEB_BOOKS_DIRECT_ACCESS_PORT=22222` and access it through `http://localhost:22222`


### Guide : Calibre Web new users

To add a matching plex user to Calibre web, 
you can check registerd plex username/mail in Ombi user list

* Admin / Users / Add New user
    * Username : same as plex username
    * Password : anything you want
    * Mail : same as plex mail
    * Language : choose a language for UI


Each user can set himself it's kindle mail. Calibre-web convert on the fly the sent ebook as mobo format for kindle if necessary.



## Calibre Web for press

*For press, do the same than books but replace `books` by `press`*

Into Organizr2

    * Image manager
        * Add image file `press_logo.png` from https://github.com/StudioEtrange/mambo/tree/master/pool/artefacts/img

Into Calibre Web

    * Admin / Configuration / Edit UI Configuration
        * Remove view by author and publisher


# Calibre

NOTE : to copy/paste inside calibre use Ctrl+shift+alt


### 1.Configuration

* Start service
    `./mambo up calibre`



Into Organizr2

    * Add a tab in Organizr2 menu
    * Tab editor / add a tab ("plus" button)
        * Tab name : Calibre - MUST be same name as listed in `mambo services list` - ignore case
        * Tab Url : `https://calibre.mydomain.com`
        * Choose image : cops
    * Tab editor / Tabs list 
        * Group : Co-Admin

Into Calibre

    * recommended action to add to toolbar
        * Preferences / Toolbars & menus / main toolbar
            * "Embed Metadata" action (FR : "integrer metadonnees") - for any file format
            * "Polish book" action (FR : "polir livres") - for ePub and AZW3 files
                * Update metadata in ebook
                * Update the cover in ebook
                * Remove unused CSS
                * Losslessly compress image
                * to not keep an original file : Preferences / Tweaks / Save origin file when... / False (Click on restart calibre)
    * recommended plugins
        * Preferences / Advanced / Plugins / Get new plugins
            * "Modify ePub" - for ePub files
            * "Quality check" - for ePub files
            * "Babelio" plugins - for babelio.com metadata https://www.mobileread.com/forums/showthread.php?t=294421 (Load plugin from file : babelio_calibre.zip)
            * "Mass Search/Replace" - Usefull to take care of press/magazines
    * all calibre database folders are in folder `/calibredb` (i.e /calibredb/books, /calibredb/press)

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
## HTTP/HTTPS Configuration

HTTPS redirection

* By default HTTP to HTTPS auto redirection is active
* To enable/disable HTTPS only access to each service, declare them in `NETWORK_SERVICES_REDIRECT_HTTPS` variable. An autosigned certificate will be autogenerate
    * NOTE : some old plex client do not support HTTPS (like playstation 3) so plex might be excluded from this variable

* ie in user env file : 
    ```
    NETWORK_SERVICES_REDIRECT_HTTPS=traefik ombi organizr2
    ```


## VPN

* see documentation in tango https://github.com/StudioEtrange/tango/blob/master/README.md

----
# Mambo Plugins

List of available plugins

## Transmission PIA port

* Plugin name : transmission_pia_port

* Allow port forwarding with PIA vpn provider
    * first, ask for an open port to enter your vpn on the active VPN connexion
    * second, set transmission with this remote port

* This plugin is by declared as active into mambo and declared as attached to transmission but must be manually launched
    * see declaration in mambo.env : `TANGO_PLUGINS=transmission_pia_port%!transmission`
    * launch this plugin to set transmission remote port : `./mambo plugins exec-service transmission`
    * To declare it as aut launched at each transmission launch set in your pwn mambo.env file `TANGO_PLUGINS=transmission_pia_port%transmission`

### Usage

* Declare a vpn connection provided by PIA and attached it to transmission services
    * choose a server. All servers support port forwarding except from USA
    ```
    VPN_1_PATH=../mambo-data/vpn/pia_ovpn_default_recommended_conf_20200509
    VPN_1_VPN_FILES=Switzerland.ovpn
    VPN_1_VPN_AUTH=user;password
    VPN_1_DNS=1
    VPN_1_SERVICES=transmission
    ```
    * To get PIA ovpn configuration files : https://www.privateinternetaccess.com/helpdesk/kb/articles/where-can-i-find-your-ovpn-files

    * restart
    ```
    # must stop vpn and transmission to remove containers
    ./mambo down <vpn_id>
    ./mambo down transmission
    ./mambo up transmission
    # wait for transmission docker container to be healthy then launch plugin execution - NOTE : <vpn_id> is auto launched because is is declared as attached to transmission (see VPN_1_SERVICES)
    ./mambo plugins exec-service transmission
    ```

* Check settings in transmission : Config / Network / port

## Troubleshooting


* Problem with a volume
    * May occurs when you move some folder with your data
    * FIX : delete docker volume with `docker volume rm <volumename>`
    * Sample
    ```
       ERROR: Configuration for volume tango_shared_internal_data specifies "device" driver_opt /foo/folder/tango_shared, but a volume with the same name uses a different "device" driver_opt (/foo/bar/tango_shared). If you wish to use the new configuration, please remove the existing volume "tango_shared_internal_data" first:
        $ docker volume rm tango_shared_internal_data
    ```