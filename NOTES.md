# Various notes


Various notes, test, links, code... made while designing Mambo

## Tools & Distribution


### Complete distribution

* cloudbox 
    * https://github.com/Cloudbox/Cloudbox
    * docker based
    * ansible config script for service and install guide for each service
    * cloudbox addon https://github.com/Cloudbox/Community
* openflixr https://www.openflixr.com/ - full VM
* autopirate
    * https://geek-cookbook.funkypenguin.co.nz/recipes/autopirate/
    * docker based - use traefik1 + oauth2 proxy
* a media stack on docker with traefik1 https://gist.github.com/anonymous/66ff223656174fd39c76d6075d6535fd
* another media stack https://gitlab.com/guillaumedsde/docker-media-stack/-/tree/master
* htpcBeginner based on traefik2 and docker https://github.com/htpcBeginner/docker-traefik
* complete guide for a full media distribution install
    * docker, traefik2, traefik2 secure hearders, cloudflare, oauth2, guacamole
    * https://mediacenterz.com/ultimate-docker-home-server-avec-traefik-2-letsencrypt-et-oauth-2020/



### File management tools

* FileBot - The ultimate TV and Movie Renamer filebot ansible role https://github.com/Cloudbox/Community/blob/master/roles/filebot/tasks/main.yml

### Video management tools

* Unmanic - Video files converter with web ui and scheduler https://github.com/Josh5/unmanic



### Generic download tools

* Aria2 download utility aria2
    * https://aria2.github.io/ - support standard download method and bitorrent and metalink format
    * http://ariang.mayswind.net/ - frontend
    * https://github.com/lukasmrtvy/lsiobase-aria2-webui - docker image

* youtube-dl download online videos
    * https://ytdl-org.github.io/youtube-dl/
    * HTML GUI for youtube-dl : https://github.com/Rudloff/alltube
    ```
    ./youtube-dl -f best --audio-format best --write-sub --all-subs --sub-format srt --convert-subs srt --embed-subs -o "%(title)s.%(ext)s" --recode-video mkv <URL>
    ```

### various

* Varken - monitoring dashboard
    * https://github.com/Boerderij/Varken
    * standalone application that display dashboard for Plex, Sonarr, SickChill, Radarr, Tautulli, Ombi, Lidarr
    * use InfluxDB/Grafana


## Plex

### Links

* guides https://plexguide.com/

* install some agent and scanner https://github.com/Cloudbox/Community/wiki/Plex-Scanners-and-Agents 

* dashboard stat : https://github.com/Boerderij/Varken

* freebox revolution plex client : https://www.freenews.fr/freenews-edition-nationale-299/apps-jeux-177/on-a-teste-p2f-client-plex-freebox-revolution

* plex management scripts : https://github.com/blacktwin/JBOPS

* webtool plugin ansible installation : https://github.com/Cloudbox/Cloudbox/blob/master/roles/webtools-plugin/tasks/main.yml

### Plex Auth

* PHP based Plex authentification https://github.com/hjone72/PlexAuth
* An LDAP server that uses Plex as the provider https://github.com/hjone72/LDAP-for-Plex

### IPTV / DVR

* xeTeVe - M3U Proxy for Plex DVR and Emby Live TV.
    * https://forums.plex.tv/t/xteve-iptv-for-plex-dvr/278500
    * https://github.com/xteve-project/xTeVe

### Plex plugins

*plex plugins have been deprecated*

* Kitana : A responsive Plex plugin web frontend. Kitana exposes your Plex plugin interfaces "to the outside world". https://github.com/pannal/Kitana

* subzero : subtitle plugins 
    * https://github.com/pannal/Sub-Zero.bundle/
    * need kitana
    * in someway should disappear and be integrated in bazaarr ? (https://www.reddit.com/r/PleX/comments/9n9qjl/subzero_the_future/)

* webtool : some tools to manage plex and plugins
    * install plugin webtool https://github.com/Cloudbox/Cloudbox/blob/master/roles/webtools-plugin/tasks

* traktv plugin 
    * http://trakt-for-plex.github.io/configuration
    * Add a sync between a plex user and its trakt account
    * install https://github.com/Cloudbox/Cloudbox/tree/master/roles/trakttv-plugin/tasks
    ```
    How to use traktv plugin :
    1-Plex owner go to http://trakt-for-plex.github.io/configuration
    2-Select "Accouns" and add a user and choose a name
    3-Pick trakt.tv give pin link (https://trakt.tv/pin/xxx) to the plex user who will respond with a code. Plex owner fill trakt fill with this code
    4-Give plex pin code to the plex user and ask him to login into  https://plex.tv/pin 
    5-Save the configuration !
    6-The user may now visit https://trakt.tv/dashboard and share its profile page https://trakt.tv/users/userid
    ```


## Organizr

### Links

* automated organizr2 installation : https://github.com/causefx/Organizr/issues/1370
* various
    * https://guydavis.github.io/2019/01/03/nginx_organizr_v2/
    * https://www.reddit.com/r/organizr/comments/axbo3r/organizr_authenticate_other_services_radarr/
* after organizr auth redirect to wanted page STILL NOT FULLY WORK organizr2 and traefik2 auth : 
    https://github.com/causefx/Organizr/issues/1240
    https://docs.organizr.app/books/setup-features/page/serverauth
* organizr2 and nginx : https://guydavis.github.io/2019/01/03/nginx_organizr_v2/
* organizr2 + nginx (using subdomains or subdirectories) + letsencrypt https://technicalramblings.com/blog/how-to-setup-organizr-with-letsencrypt-on-unraid/
* organizr + nginx samples for several media/download services https://github.com/vertig0ne/organizr-ngxc/blob/master/ngxc.php


* Organizr / calibreweb auth
    * configure organizr Auth Proxy : https://github.com/causefx/Organizr/issues/1215
    * organizr Auth proxy is case sensitiv https://github.com/causefx/Organizr/issues/1437

### Access through traefik without organizr auth for service api

* add specific router for service api
* https://github.com/htpcBeginner/docker-traefik/issues/27

* Sonarr : ```Host(`sonarr.$DOMAINNAME`) && PathPrefix(`/api`)```
* LazyLibrarian : ```Host(`lazylibrarian.$DOMAINNAME`) && PathPrefix(`/opds`)```
* Radarr : ```Host(`radarr.domain.com`) && (Headers(`X-Api-Key`, `$RADARR_API_KEY`) || Query(`apikey=$RADARR_API_KEY `))```
* Sabnzbd : ```Host(`sabnzbd.$DOMAINNAME`) && Query(`apikey=$SABNZBD_API_KEY`)```
* Bazaar : ```Host(`bazarr.$DOMAINNAME`) && (Headers(`X-Api-Key`, `$BAZARR_API_KEY`) || Query(`apikey`, `$BAZARR_API_KEY`))```

### organizr and reverse proxy interaction

* You may want to write reverse proxy rules to 

    * firstly reverse proxy the service because `Tab URL` may not be reachable from outside network (internet)
    * secondly use organizr authorization API [https://docs.organizr.app/books/setup-features/page/serverauth]
    * thirdly use organizr SSO by playing around http header with reverse proxy role 
        * https://docs.organizr.app/books/setup-features/page/sso
        * reverse proxy rule sample : https://github.com/vertig0ne/organizr-ngxc/blob/master/ngxc.php]

    * lastly using nginx reverse proxy rules for organizr to modify the response and inject some code like CSS for cutom thema with `sub_filter` instruction
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

### Organizr and authentification

Use organizr to check user is authentified from organizr auth page : organizr can be used as a auth mechanism in front of a service

* organizr expose an API for this (there is two versions or organizr v1 and v2)
* This api can check if a user is already logged and belong to a GROUPID. 
    * if true return HTTP 200 and headers `X-Organizr-User: username` and `X-Organizr-Email: user@gmail.com` and `X-Organizr-Group: 0` (in more recent versions) - These headers can be used to autologin into service like Calibreweb
    * if false return HTTP 401 by default
    * or if false return HTTP 302 and redirect to the organizr login page IF `Settings / System Settings / Main / Security / Enable Traefik Auth Redirect`
* URL api v1 : http://organizr2.domain.com.api/api/?v1/auth&group=GROUPID
* URL api v2 : http://organizr2.domain.com.api/api/v2/auth?group=GROUPID
* This api an be used with a traefik middleware forwardauth attached to service router. When using an organizr to auto login into service do not forget to add an `authRespnseHeaders` to traefik middleware : `forwardauth.authResponseHeaders = ["X-Organizr-User"]`


Auto login into organizr portail (=bypass organir login mechanism)

* In organizr the Auth Proxy functionnality allow ONLY to auto login into organizr and bypass authentification
    * This do not help in anyway to make SSO nor auto login into any service
    * Example to allow any HTTP request with X-WEBAUTH-USER to be autologged into organizr :
        * Settings / System Settings / Main / Auth Proxy
            * Auth Proxy : enable
            * Auth Proxy Header Name : X-WEBAUTH-USER (this is the default value)
            * Auth Proxy Whitelist : ip or subnet like 0.0.0.0/0 (filter to autorize request only from this ip or subnet)


### Organizr and Plex SSO

Plex SSO through organizr means : log into organizr then we are auto logged into plex also with the same acount

* According to the doc Organizr Plex SSO doesn't work if Plex Reverse Proxy is a subdomain https://docs.organizr.app/books/setup-features/page/sso
* To still use subdomain and have SSO, we need to add another access with subfolder to plex
    * solution for traefik 1 : https://www.reddit.com/r/organizr/comments/edcpvz/plex_sso_and_traefik_401_unauthorized/fbxmh4y/?utm_source=reddit&utm_medium=web2x&context=3
    * same solution for traefik 2 :
        * edit organizr tab to access to plex to url http://organizr2.comain.com.plex
        * set organizr plex sso configuration (see https://docs.organizr.app/books/setup-features/page/sso) 
        * add two routes (/plex and / web) to organizr2 router that will go to plex service 
        ```
organizr2:
    image: organizr/organizr
    labels:
        - "traefik.enable=true"
        # auth middlewares
        - "traefik.http.middlewares.myauth.address=https://organizr2.domain.com:443/api/?v1/auth&group=1"
        - "traefik.http.middlewares.myauth.forwardauth.tls.insecureSkipVerify=true"
        - "traefik.http.middlewares.myauth.forwardauth.trustforwardheader=true"
        # service
        - "traefik.http.services.organizr2.loadbalancer.server.port=80"
        - "traefik.http.services.organizr2.loadbalancer.server.scheme=http"
        - "traefik.http.services.organizr2.loadbalancer.passhostheader=true"
        # routers
        - "traefik.http.routers.organizr2-secure.entrypoints=web_main_secure"
        - "traefik.http.routers.organizr2-secure.rule=HostRegexp(`{subdomain:organizr2.}{domain:domain.com}`)"      
        - "traefik.http.routers.organizr2-secure.priority=50"
        - "traefik.http.routers.organizr2-secure.service=organizr2"
        - "traefik.http.routers.organizr2-secure.tls=true"
        - "traefik.http.routers.organizr2-secure.tls.domains[0].main=organizr2.domain.com"
        # routers middleware
        - "traefik.http.routers.organizr2-secure.middlewares=error-middleware"
        # SPECIAL tip to make organizr plex SSO work : have another way to access plex as a subfolder of organizr2 dns name
        - "traefik.http.middlewares.organizr2-plex-stripprefix.stripprefix.prefixes=/plex, /plex/"
        - "traefik.http.routers.organizr2-plex-secure.entrypoints=web_main_secure"
        - "traefik.http.routers.organizr2-plex-secure.rule=HostRegexp(`{subdomain:organizr2.}}{domain:domain.com}`) && (PathPrefix(`/plex`) || PathPrefix(`/web`))"
        - "traefik.http.routers.organizr2-plex-secure.priority=100"
        - "traefik.http.routers.organizr2-plex-secure.service=plex"
        - "traefik.http.routers.organizr2-plex-secure.tls=true"
        - "traefik.http.routers.organizr2-plex-secure.tls.domains[0].main=organizr2.domain.com"
        # add myauth to authorize access to these url http://organizr2.domain.com/plex http://organizr2.domain.com/web only after logged into organizr
        - "traefik.http.routers.organizr2-plex.middlewares=organizr2-plex-stripprefix,myauth"
        - "traefik.http.routers.organizr2-plex-secure.middlewares=organizr2-plex-stripprefix,myauth"
        # NOTE : do not activate error-middleware, if so plex service cannot ask for authentification
    networks:
        - default
    expose:
        - 80
        ```


## audiobooks

* how to manage metadata books collection for booksonic and plex with mp3tag : https://github.com/seanap/Plex-Audiobook-Guide/blob/master/README.md



### Booksonic

* Initial Configuration
    * access to Booksonic - a 'getting started' page will appear
    * change default login password
    * Setup Media Folder : add a media folder. Shoud be one from `TANGO_ARTEFACT_FOLDERS` list, mounted under `/media/`

* Booksonic-App android reader
    * build from source 
        * https://amp.reddit.com/r/Booksonic/comments/hboaua/building_from_source/
        * instructions : https://github.com/mmguero-android/Booksonic-Android

### Booksonic and Organizr2 

Into Organizr2

* Add a tab in Organizr2 menu
    * Tab editor / add a tab ("plus" button)
        * Tab name : Booksonic - MUST be same name as listed in `mambo services list` - ignore case
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


## ebooks

### books server setup scenario

* scenario 1 : `Calibre content server` AND `calibre management desktop` AND `calibre binaries utilities` (3 products)
    * https://manual.calibre-ebook.com/generated/en/calibre-server.html
    * https://github.com/linuxserver/docker-calibre
    * https://github.com/cgspeck/docker-rdp-calibre

* scenario 2 : `calibre-web` - alone as server and collection management and reader
    * Calibre-Web is a web app providing a clean interface for browsing, reading and downloading eBooks using an existing Calibre database
    * https://github.com/janeczku/calibre-web
    * https://github.com/linuxserver/docker-calibre-web Can convert between ebook formats with a docker mod and can initialize an empty calibre db with my docker mod (from studioetrange)
    * https://github.com/Technosoft2000/docker-calibre-web  <-- NOT CHOOSEN
    * https://github.com/linuxserver/docker-calibre-mod (calibre binaries utilities)

* scenario 3 : `Ubooquity` - alone as server and collection management and reader
    * Ubooquity is a free home server for your comics and ebooks library
    * http://vaemendis.net/ubooquity/
    * https://github.com/linuxserver/docker-ubooquity
    * theme plex pour ubooquity https://github.com/FinalAngel/plextheme
    * theme comixology 
        * https://ubooquity.userecho.com/communities/1/topics/756-comixology-theme-v2-finally-released
        * https://github.com/scooterpsu/Comixology_Ubooquity_2
        * https://imgur.com/a/786RDqI
    * embed metadata in ebook from a calibre database to be read with ubooquity https://vaemendis.github.io/ubooquity-doc/pages/calibre-sharing.html


### Tools

* alfred - A web based comic book reader and library manager. https://github.com/kaethorn/alfred

* ComicTagger
    * ComicTagger is a multi-platform app for writing metadata to digital comics, written in Python and PyQt
    * https://github.com/comictagger/comictagger

* Manga Tagger
    * A tool to rename and write metadata to digital manga chapters 
    * comic tagger alternative for manga
    * Writes metadata in the ComicRack format 
    * https://github.com/Inpacchi/Manga-Tagger

* Mylar - download tool
    * Mylar is an automated Comic Book (cbr/cbz) downloader program for use with NZB and torrents written in python. It supports SABnzbd, NZBGET, and many torrent clients in addition to DDL.
    * https://github.com/mylar3/mylar3


* ZenCBR – Comic Book Archive Maintenance Utility
    * a windows tool to manage cbr/cbz files
    * http://www.zentastic.com/blog/2012/01/30/zencbr-comic-book-archive-maintenance-utility/
    

### ubooquity

* Test

    ```
    export MAMBO_HOME="$HOME/mambo"
    cd ${MAMBO_HOME}
    # INSTALL
    mkdir -p ${MAMBO_HOME}/data/ubooquity
    mkdir -p ${MAMBO_HOME}/data/ubooquity/themes
    # download a theme based on "comixology"
    wget https://github.com/scooterpsu/Comixology_Ubooquity_2/releases/download/v3.4/comixology2.zip -O ${MAMBO_HOME}/data/ubooquity/themes/comixology2.zip
    unzip ${MAMBO_HOME}/data/ubooquity/themes/comixology2.zip -d ${MAMBO_HOME}/data/ubooquity/themes
    # START
    docker stop ubooquity && docker rm ubooquity 
    docker run -it \
    --name=ubooquity \
    -e PUID=$(id -u) -e PGID=$(id -g) \
    -e TZ=Europe/Paris\
    -e MAXMEM=1024 \
    -p 2202:2202 \
    -p 2203:2203 \
    -v ${MAMBO_HOME}/data/ubooquity:/config \
    -v /media/MEDIA/EBOOKS:/books \
    linuxserver/ubooquity:latest
    ===> http://localhost:2203/ubooquity/admin
    ===> http://localhost:2202/ubooquity
    ===>  http://localhost:2202/ubooquity/opds-comics
    ===>  http://localhost:2202/ubooquity/opds-books
    In admin, add folder /books as comics (and remove the default one)
    in admin, choose theme "comixology"
    ```


### calibre-web

* Update calibre-web database - if automated will work as a watch folder : usefull for Lazylibrarian
    ```
    if [ "$(ls -A /[autoaddfolder])" ]; then
        calibredb add -r "/[autoaddfolder]" --library-path="/[calibrelibraryfolder]"
        rm /[autoaddfolder]/*
    fi
    ```
    this script : https://github.com/janeczku/calibre-web/issues/412
    feature request : https://github.com/janeczku/calibre-web/issues/344

* Test Calibre-web + calibre docker-mod
    ```
    CALIBRE_WEB_VERSION="24ae7350f5b749127b48e66758bc3f449296c65f"
    export CALIBRE_WEB_DOCKER_VERSION="${CALIBRE_WEB_VERSION}"
    export CALIBRE_RELEASE_DOCKERMOD_VERSION="4.6.0"
    export MAMBO_HOME="$HOME/mambo"
    # INSTALL and BUILD (a dev version)
    git clone https://github.com/StudioEtrange/docker-calibre-web
    cd docker-calibre-web
    docker build --build-arg CALIBREWEB_RELEASE="${CALIBRE_WEB_VERSION}" -t=linuxserver/calibre-web:${CALIBRE_WEB_DOCKER_VERSION} .
    # START
    docker stop calibre-web && docker rm calibre-web
    docker run --name calibre-web -d -v ${MAMBO_HOME}/data/calibre-web:/config -v /media/MEDIA/EBOOKS/CALIBRE_DB1:/books  -p 8080:8083 -e PUID="$(id -u)" -e PGID="$(id -g)" -e TZ="Europe/Paris" -e DOCKER_MODS="studioetrange/calibre-mod:${CALIBRE_RELEASE_DOCKERMOD_VERSION}" linuxserver/calibre-web:${CALIBRE_WEB_DOCKER_VERSION}
    docker logs calibre-web -f

    ===> http://host:8080
    ```
    ```
    ===> http://host:8080
    * Location of Calibre database : /books
    Next
    default login : admin/admin123
    * Admin / Configuration / UI Configuration / View Configuration : caliblur Theme
    * Admin / Configuration / Basic Configuration / Feature Configuration : Enable uploading
    * Admin / Configuration / Basic Configuration / External binaries : 
    Use calibre's ebook converter 
    Path to convertool: /usr/bin/ebook-convert
    Location of Unrar binary : /usr/bin/unrar
    * Admin / change smtp settings
    SMTP hostname : smtp.gmail.com
    SMTP port : 465
    Encryption : SSL/TLS
    SMTP login : info.mambo.media@gmail.com
    SMTP Password: xxxx
    From e-mail : Chimere & Harpie <info.mambo.media@gmail.com>
    * USER who want to use send to kindle MUST have download permission
    ```




### calibre

* Calibre desktop management is a tool to organize books collection
* Calibre content server is an ODPS server

* NOTE : if editing calibre database with  calibre desktop management , and view it through calibre-web to refresh calibre-web do "Reconnect to calibre DB"
 
* Test calibre desktop management with a web access with guacamole 
    ```
    export CALIBRE_DOCKER_VERSION="v4.6.0-ls39"
    export MAMBO_HOME="$HOME/mambo"
    # START
    docker stop calibre && docker rm calibre 
    docker run -d \
    --name=calibre \
    -e PUID=$(id -u) -e PGID=$(id -g) \
    -e TZ=Europe/Paris \
    -e GUAC_USER=mambo \
    -e GUAC_PASS="$(echo -n mambo | openssl md5 | cut -d" " -f2)" \
    -p 8090:8080 \
    -p 8091:8081 \
    -v /media/MEDIA/EBOOKS:/books \
    -v ${MAMBO_HOME}/data/calibre:/config \
    linuxserver/calibre:${CALIBRE_DOCKER_VERSION}
    ====>  http://localhost:9080
    choose a folder for calibre library : /books/CALIBRE_DB1
    ```

### calibre-mod

* calibre-mod add calibre binaries and dependencies necessary to enable ebook conversion into a linuxserver's.io docker image
    * in mambo could be used with lazylibrarion and calibre-web

* a personal fork of calibre-mod to store a calibre-mod version for each calibre version
    * https://github.com/StudioEtrange/docker-calibre-mod
    * initialize an empty calibre database
    * TODO inject this code https://github.com/cgspeck/docker-rdp-calibre/blob/master/firstrun.sh into studioetrange/docker-calibre-mod ?

### Lazylibrarian - download tool

* LazyLibrarian is a SickBeard, CouchPotato, Headphones-like application for ebooks, audiobooks and magazines
    * https://gitlab.com/LazyLibrarian/LazyLibrarian 
    * calibre + lazylibrarian : https://github.com/Thraxis/docker-lazylibrarian-calibre
    * lazylibrarian alone : https://github.com/linuxserver/docker-lazylibrarian

* Test Lazylibrarian + calibre docker-mod

    ```
    export CALIBRE_RELEASE_DOCKERMOD_VERSION="4.6.0"
    export LAZYLIBRARIAN_DOCKER_VERSION="a78d76ad-ls114"
    export MAMBO_HOME="$HOME/mambo"
    docker stop lazylibrarian && docker rm lazylibrarian
    docker run --name lazylibrarian -d -v ${MAMBO_HOME}/data/lazylibrarian:/config -v /media/MEDIA/EBOOKS:/books  -v ${MAMBO_HOME}/download:/downloads -p 8020:5299 -e PUID="$(id -u)" -e PGID="$(id -g)" -e TZ="Europe/Paris" -e DOCKER_MODS="studioetrange/calibre-mod:${CALIBRE_RELEASE_DOCKERMOD_VERSION}" linuxserver/lazylibrarian:${LAZYLIBRARIAN_DOCKER_VERSION}
    ```



## Torrent


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

* transmission family setup
    * docker images with openvpn client
        * docker bundle transmission with openvpn client, stop transmission when openvpn down, dinamucly configure remote port for pia (private internet access) and perfectprivacy vpn providers (see https://github.com/haugene/docker-transmission-openvpn/blob/master/transmission/start.sh)
        https://github.com/haugene/docker-transmission-openvpn


* rtorrent family setup
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


## Music


### Tools

* Server
    * plays music from local disk, Spotify, SoundCloud, Google Play Music, and more.
    * https://github.com/mopidy/mopidy

* Player
    * Modipy web client https://github.com/martijnboland/moped (inactive)
    * Modipy web client https://github.com/dirkgroenen/mopidy-mopify (active)
    * Modipy web client https://github.com/jaedb/Iris (active) (best ?)
    * Modipy client https://github.com/pimusicbox/mopidy-musicbox-webclient (active)
    * Plexamp - A beautiful Plex music player for audiophiles, curators, and hipsters
        * https://plexamp.com/
        * ios/android/macos/windows/linux
        * need plex pass

* Download
    * Lidarr - for Usenet and BitTorrent users : https://lidarr.audio/

* Metadata
    * Picard - cross-platform (Linux/Mac OS X/Windows) application written in Python and is the official MusicBrainz tagger.
        * https://picard.musicbrainz.org/
        * https://github.com/metabrainz/picard


## Games

### Tools

* nodejs library to ping game server https://github.com/gamedig/node-gamedig

### Complete retrogaming distribution

* RecalBox
    * distribution emulation with EmulationStation2 + Retroarch
    * https://www.recalbox.com/
    * https://gitlab.com/recalbox/recalbox
    * https://gitlab.com/recalbox/recalbox-emulationstation
    * https://gitlab.com/recalbox/recalbox-themes
    * share metadata on network (FR) : https://recalbox.gitbook.io/documentation/v/francais/tutoriels/reseau/partage/charger-ses-roms-depuis-un-partage-reseau-samba-un-nas-par-exemple

* Batocera
    * fork recalbox
    * for linux
    * best for PC than recalbox ?
    * bug on atom cherytrail : https://forum.batocera.org/d/900-batocera-sur-z83-ii-intel-atom-x5-z8350-works-well-but-no-sound/5
    * share metadata on network : https://wiki.batocera.org/store_games_on_a_nas
    * use pacman as package manager and build your own package : https://wiki.batocera.org/pacman_package_manager

* Retropie
    * built primarly for raspberrypi
    * distribution emulation with EmulationStation (default frontend) + Retroarch + Others emulators
    * https://retropie.org.uk/
    * https://github.com/RetroPie
    * https://github.com/RetroPie/EmulationStation
    * https://github.com/retropie/retropie-setup/wiki/themes
    * https://github.com/search?q=org%3ARetroPie+es-theme&unscoped_q=es-theme

* recalbox vs retropie 
    * https://www.domo-blog.fr/comparatif-solutions-retrogaming-raspberry/
    * https://www.electromaker.io/blog/article/retropie-vs-recalbox-vs-lakka-for-retro-gaming-on-the-raspberry-pi

* Retroarch 
    * https://www.retroarch.com/
    * RetroArch is a kind frontend for emulators, game engines and media players.
    * it also includes a variety of emulators as cores

### Emulators

* list of emulators http://nonmame.retrogames.com/


### Web Emulators


* List of web emulators https://github.com/pengan1987/computer-museum-dnbwg

* JSMESS Mame 
    * mame javascript
    * build doc : https://docs.mamedev.org/initialsetup/compilingmame.html#emscripten-javascript-and-html
    * build exemple + use in emularity : https://github.com/simonjohngreen/oldguysarcade

* em-Dosbox
    * https://github.com/dreamlayers/em-dosbox
    * js version of dosbox

* js api over em-Dosbox (have an embedded version of em-Dosbox)
    * https://js-dos.com/
    * https://github.com/caiiiycuk/js-dos
    
* Dosee
    * https://github.com/bengarrett/DOSee
    * web frontend (based on work from emularity) for dos games wjhch embed em-dosbox

### Web launcher

* WebtroPie
    * https://github.com/gazpan/WebtroPie
    * technical discussion : https://retropie.org.uk/forum/topic/10164/webtropie
    * web rom brower and manager for retropie with emulationstation theme
    * adaptation for batocera : https://github.com/Broceliande/batocera.webtropie
    * some tests : https://gist.github.com/StudioEtrange/235cd22d786c4a0f7fe7ca7e336610ea

* Emularity
    * https://www.archiveteam.org/index.php?title=Emularity
    * https://github.com/db48x/emularity
    * technical documentation : https://github.com/db48x/emularity/blob/master/TECHNICAL.md
    * loader used by internet archive.org
    * 3 supported emulators, MAME (=JSMESS) for 60 systems, EM-DOSBox for DOS, and SAE for Amiga
    * documentaion of Internet Archive.org Emulation system : http://digitize.archiveteam.org/index.php/Internet_Archive_Emulation
    * emularity emulators and bios repository :
        * https://archive.org/download/emularity_engine_v1
        * https://archive.org/details/emularity_bios_v1 
    * Emularity software library of dos games : https://archive.org/details/softwarelibrary_msdos_games
    * Emularity sofware library for arcade games : https://archive.org/details/internetarcade
    * Emularity sofware library for console games : https://archive.org/details/consolelivingroom
    * list of all various items relative to emularity : https://archive.org/search.php?query=Emularity%20Engine


* Retrojolt
    * https://github.com/gamejolt/retrojolt 
    * it is a wrapper around emularity AND an emulator builder for emularity
    * example usage of retrojolt from inside gamejolt website : https://github.com/gamejolt/gamejolt/blob/master/src/gameserver/components/embed/rom/rom.ts 
    * example usage of retrojolt emulator compile scripts https://github.com/gamejolt/retrojolt/tree/main/scripts
    * test build retroljolt
        ```
        # NEED nodejs and yarn
        git clone https://github.com/gamejolt/retrojolt 
        cd retrojolt
        git submodule init
        git submodule update
        yarn build
        yarn start
        see http://localhost:8080
       ```

### Website running emulators

* Various list
    * https://www.retrogames.cc/
    * http://emulator.online/ (flash emulator)
    * https://lifehacker.com/the-best-web-sites-to-get-your-retro-gaming-fix-1823765757
    * http://pica-pic.com/ (flash)
    * https://dos.zczc.cz/ (with emularity and em-dosbox)
        * https://github.com/rwv/chinese-dos-games-web
        * https://github.com/rwv/chinese-dos-games (metadata)

* From archive.org
    * Emularity software library of dos games : https://archive.org/details/softwarelibrary_msdos_games
    * Emularity sofware library for arcade games : https://archive.org/details/internetarcade
    * Emularity sofware library for console games : https://archive.org/details/consolelivingroom


### Emulator frontend

A frontend is a launcher of emulators

* List
    * https://emulation.gametechwiki.com/index.php/Comparison_of_Emulator_Frontends

* pegasus
    * https://pegasus-frontend.org/
    * https://github.com/mmatyas/pegasus-frontend
    * opensource
    * multiplatform (Windows, Linux, Mac, Android, all Raspberries, Odroids)
    * support games library from emulators and steam and gog
    * integrated in retropie installer
    * Theme Switch-like adaptated for Retroid Pocket2 https://github.com/dragoonDorise/RP-Switch
    * Guide and preconfiguration data to install pegasus on Retroid Pocket2 https://github.com/dragoonDorise/pegasus-rp2-metadata

* EmulationStation
    * integrated in retropie installer

* Dig
    * https://digdroid.com/
    * android only

* launchbox (windows only) - game front end
* openemu (mac only) - game front end
* lutris (linux only) - game front end

* AttractMode
    * http://attractmode.org/
    * https://github.com/mickelson/attract
    * Attract-Mode is a graphical frontend for command line emulators such as MAME, MESS and Nestopia.
    * Linux and macos
    * integrated in retropie installer

* Snowflake
    * https://github.com/SnowflakePowered/snowflake
    * framework to build frontend
    * able to build frontend with a metadata backend (server)    
    * under construction


### Emulation : Rom management tools

* List
    * (FR) http://www.emu-france.com/utilitaires/24-utilitaires-multi-systemes/316-managers/

* Romulus
    * https://romulus.cc/ 
    * non opensource
    * windows only
    * weird behaviour : erase files
    * good updater and search of DAT files
    * easyier than romcenter or clrmamepro
    * tutorial by recalbox (FR) : https://recalbox.gitbook.io/documentation/v/francais/tutoriels/utilitaires/gestion-des-roms/romulus-rom-manager

* Romvault
    * http://www.romvault.com/ 
    * https://github.com/RomVault/RVWorld
    * windows only
    * tutorial : https://www.youtube.com/embed/yUOIYYbZuAg
    * can manipulate several DAT files simultaneously

* Romcenter
    * http://www.romcenter.com/
    * tutorial : https://www.youtube.com/watch?v=1JtIh5u2Ko4
    * good enough

* JRomManager 
    * https://github.com/optyfr/JRomManager
    * opensource

* ClrmamePro
    * ​https://mamedev.emulab.it/clrmamepro/

* ROMba
    * https://github.com/uwedeportivo/romba
    * command line
    * linux - macos
    * While its core functionality is similar to tools like ROMVault and CLRMamePRO, ROMba takes a unique approach by storing ROMs in a de-duplicated way, and allowing you to "build" any set you need on demand.

* Guide : Convert SNES ROM's Into CIA's & Install Them ! (OLD/NEW 3DS/2DS) 
    * https://www.youtube.com/watch?v=G6zkMl9UTJM


### Emulation : Rom database

* A guide how to manage DAT and rom : https://www.oreilly.com/library/view/gaming-hacks/0596007140/ch01s13.html

* DAT files
    * Datomatic No Intro http://datomatic.no-intro.org/
    * TOSEC https://www.tosecdev.org/
    * https://www.advanscene.com/
    * http://www.progettosnaps.net/dats/

* DAT files management
    * SabreTools 
        * https://github.com/SabreTools/SabreTools
        * command line
        * windows
    * DatUtil
        * http://www.logiqx.com/Tools/DatUtil/
        * command line
        * DatUtil was created to aid in the creation of dat files for Rom Managers such as ClrMamePro and RomCenter
        * tutorial (FR) ! https://forum.recalbox.com/topic/4571/tutorial-datutil

* EverDrive-Packs-Lists-Database
    * https://github.com/SmokeMonsterPacks/EverDrive-Packs-Lists-Database
    * The EverDrive Packs Lists Project is an archival research initiative with the goal of allowing users to build real-hardware optimized ROM packs based on suggested file/folder layouts compiled by SmokeMonster.


### Scrapper

* Scrapers list from recalbox (FR) : https://recalbox.gitbook.io/documentation/v/francais/tutoriels/utilitaires/gestion-des-scrappes/liste-des-utilitaires-de-scrape

* Lars Muldjord's Skyscraper 
    * https://github.com/muldjord/skyscraper
    * integration with EmulationStation, AtrtractMode, Pegasus frontens
    * for linux (works on win and macos but nonofficaly)
    * use various source for games items

* Steven Selph's Scraper 
    * https://github.com/sselph/scraper
    * ssscraper with fastscraper : https://forum.recalbox.com/topic/2594/batch-scrape-your-roms-on-your-pc-fastscraper


* Skraper 
    * https://www.skraper.net/ 
    * client desktop win/linux (not macos)
    * support emulationstation metadata
    * use ScreenScraper.fr for games items, need an account for better speed
    * integration with recalbox, retropie and launchbox
    * tutorial (FR) : https://recalbox.gitbook.io/documentation/v/francais/tutoriels/utilitaires/gestion-des-scrappes/skraper-scrapper-ses-roms
    * needs a lot of space for downloaded metadata cache


* Arrm (Another Gamelist, Roms manager, and Scraper for Recalbox, Batocera, Retropie, Retrobat & Emulationstation)
    * http://jujuvincebros.fr/telechargements2/file/10-arrm-another-recalbox-roms-manager
    * windows

### Emulation : Rom download

* Links
    * http://romhustler.net/
    * https://romsmania.cc
    * https://www.nds-passion.xyz
    * https://www.3dscia.com/
    * http://www.3dsiso.com/
    * https://www.arcadepunks.com/
    * https://yelostech.com/working-best-rom-sites/
    * https://archive.org/details/MAME_0.151_ROMs
    * https://the-eye.eu/public/rom/
    * https://mega.nz/folder/P8dBVSoI#2SvU2uqK3yUVj46dSu5Xfw

* CIA download for 3DS
    * https://www.softcobra.com/ntdo/ntdo-3ts/3ts-roms/
    * http://roms3ds.com/rom-3ds-cartoon-network-punch-time-explosion-usa-multi-espanol-3ds-rom-cia/ 
    * https://isoroms.com/category/3ds/




## Network topics

* SMB vs NFS and SMB optimization : https://www.reddit.com/r/linuxquestions/comments/b5ba8t/nfs_vs_samba_whats_the_trend_nowadays/

* sniff network TCP network inside a service
    ```
    # sniff service organizr2 which internally listen on port 80
    docker exec -it -u 0:0 mambo_organizr2
    # install tcpdump
    apk add tcpdump
    # listen network trafic
    tcpdump -A -s 0 'tcp port 80 and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)'
    ```

### Game Streaming

* moonlight
    * https://moonlight-stream.org/
    * https://github.com/moonlight-stream
    * open source implementation nvidia gamestream protocol
    * client android, iOS , win, linux,Mac, web chrome, PS Vita, raspberry Pi
    * non multitenant

* parsec
    * https://parsecgaming.com/ 
    * https://github.com/parsec-cloud/web-client
    * stream a game from a PC
    * client mac/win/linux/web
    * server Hosting is only available for Windows 8.1+
    * use H265 for encoding video
    * setup with VM on unraid and parsec : https://www.reddit.com/r/unRAID/comments/d2fgv8/my_experience_with_cloud_gaming_and_an_allinone/

* rainway
    * https://github.com/RainwayApp
    * https://rainway.com
    * server windows 10
    * client web https://play.rainway.com/
    * multitenant : non
    * stream the game (an non the entire pc)


### Game : Sync game library

* FSCache linux + CIFS or NFS

* rclone sync OR rclone Union or rclone Mount

* Frontend launchbox on windows play machine + games in cloud + rclone to mount folder on windows play machine + script to download game with rclone at game launch https://www.reddit.com/r/launchbox/comments/i6wnfi/launchbox_rclonegsuite_for_unlimited_game_storage/