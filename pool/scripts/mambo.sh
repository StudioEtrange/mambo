#!/usr/bin/env bash

MODE="$1"
[ "${MODE}" = "" ] && MODE="info"

echo "---------==---- ${TANGO_APP_NAME_CAPS} SPECIFIC PATHS ----==---------"
echo Download path : [$DOWNLOAD_PATH] is mapped to {/download}
echo Plex transcode folder : [$PLEX_TRANSCODE_PATH]  {/transcode}
echo Common scripts folder : [$SCRIPTS_PATH] {/data/scripts}
echo Vault folder for nzb/torrent watch folder [$VAULT_PATH] {/download/vault}
[ "${MODE}" = "init" ] && mkdir -p /download/vault/nzb && mkdir -p /download/vault/torrent
echo generic web folder \(including newsletters,...\) [$WEB_PATH] {/data/web}


if [ "${MODE}" = "init" ]; then
    echo "---------==---- $TANGO_APP_NAME_CAPS SPECIFIC INIT SERVICES ----==---------"
    for service in ${TANGO_SERVICES_AVAILABLE}; do
        service=${service^^}
        [[ " ${TANGO_SERVICES_DISABLED} " =~ .*\ ${service,,}\ .* ]] && continue
        echo "* ${service}"
        case ${service} in
            ORGANIZR2 )
                echo L-- create [$APP_DATA_PATH/organizr2] {/data/organizr2}
                mkdir -p /data/organizr2
                ;;
            PLEX )
                echo L-- create [$APP_DATA_PATH/plex] {/data/plex}
                mkdir -p '/data/plex'
                # plex image have a bug and create Library/Application Support owner is root instead of PLEX_UID when launching the docker image 
                # so we create Library/Application Support with right owner from here
                mkdir -p '/data/plex/Library/Application Support'       
                ;;
            JDOWNLOADER2 )
                echo L-- create [$APP_DATA_PATH/jdownloader2] {/data/jdownloader2}
                mkdir -p '/data/jdownloader2'
                echo L-- create [$DOWNLOAD_PATH/jdownloader2] {/download/jdownloader2}
                mkdir -p '/download/jdownloader2'
                ;;
            TRANSMISSION )
                echo L-- create [$APP_DATA_PATH/transmission] {/data/transmission}
                mkdir -p '/data/transmission'
                echo L-- create [$DOWNLOAD_PATH/transmission] {/download/transmission}
                mkdir -p '/download/transmission'
                ;;
        esac
    done

fi