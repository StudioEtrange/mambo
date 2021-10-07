#  TODO 

* [ ] add jdownloader2 gui (instead of jdownloader headless) https://github.com/jlesage/docker-jdownloader-2

* [ ] Calibre back cover https://www.mobileread.com/forums/showthread.php?t=268119 ?

* [X] add forward auth to compose file static at each launch AND dynamic at each change ? use organizr2 api and traefik rest api provider

* [ ] lib transmission : generate encoded password for use in Authentification header

* [ ] mydjapi (mydjownloader api for organizrv2) :
    ```
    export MAMBO_HOME="$HOME/mambo"
    mkdir -p ${MAMBO_HOME}/data/myjdapi
    docker stop myjdapi && docker rm myjdapi
    docker run -d \
    --name="myjdapi" \
    -p 8075:8080 \
    -v ${MAMBO_HOME}/data/myjdapi:/config:rw \
    -e USER="XXXX" \ 
    -e PASS="XXX" \
    -e DEVICE="JDownloader@jdownloader" \
    rix1337/docker-myjd-api:latest
    ```

* [X] Advanced Direct Connect and Direct Connect protocols
    * AirDC++ https://airdcpp.net/
    * AirDC++ Web Client 
        * https://github.com/airdcpp-web/airdcpp-webclient
        * https://github.com/gangefors/docker-airdcpp-webclient


* [ ] ebooks-list : sync time window for books list with time window selected in tautulli UI ?

* each plugin can work 
    * only on some specific services
    * may require app lib
    * may require stella
    * may require some var init in tango init or mambo init
    * TODO implement restriction system on plugin, which may work only if certains criteria are ok

* [ ] sabnzbd add multicore par2
    * https://sabnzbd.org/wiki/installation/multicore-par2
    * dont need linuxserver/sabnzbd already have multicore par2
    * hotio/sabnzbd do not have par2 multicore

* [ ] nzbtomedia : ansible generate autoProcessMedia.cfg 
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
    * nzbtomedia medusa : finish nzbtomedia_medusa_settings


* description about the difference between a module, a plugin and a script (scripts_info, scripts_init, ...) are too complex

* scripts_info / scripts_init : transform into plugins ?

* webtool plugin : acces port to webtools (by default 33400) - deprecate webtools : it do not work
    * https://github.com/Cloudbox/Cloudbox/blob/c9c0f6e096370ac0dd153a289e783346be0448e7/roles/webtools-plugin/tasks/main.yml

* booksonic 
** API https://airsonic.github.io/docs/api/
** update library  : 

    SERVER='http://yourserverhere:4040'
    CLIENT='CLI'
    USERNAME='admin'
    PASSWORD='yourpasswordhere'
    curl "${SERVER}/rest/startScan?u=${USERNAME}&p=${PASSWORD}&v=1.15.0&c=${CLIENT}"



* emulator games web : webtropie with html&emularity OR retrojolt ?

* ombi bug cannot sync plex items https://github.com/tidusjar/Ombi/issues/3420

* organizr : sickbeard homepage widget : calendar bug

* why services listed in TANGO_ARTEFACT_SERVICES mount also artefact volume in TANGO_ARTEFACT_MOUNT_POINT (like sabnzbd)

* [ ] allow api access to service without organizr auth https://github.com/htpcBeginner/docker-traefik/issues/27#issuecomment-743916338 (api access for sabnzbd, lazylibrarian... like transmission)

* [X] calibre env var
    * for calibre and or calibreweb wich use calibre binary
    * taken from https://github.com/Thraxis/docker-lazylibrarian-calibre/blob/22db28939571b6a1b3416e3774b7c93807175976/Dockerfile#L10
    * ENV CALIBRE_CONFIG_DIRECTORY="/config/calibre/"
    * ENV CALIBRE_TEMP_DIR="/config/calibre/tmp/"
    * ENV CALIBRE_CACHE_DIRECTORY="/config/cache/calibre/"

* [ ] backup mambo-data
    * [ ] specific saves of calibredb files