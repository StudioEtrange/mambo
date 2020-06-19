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
            PLEX )
                echo L-- create [$APP_DATA_PATH/plex] {/data/plex}
                mkdir -p '/data/plex'
                # plex image have a bug and create Library/Application Support owner is root instead of PLEX_UID when launching the docker image 
                # so we create Library/Application Support with right owner from here
                mkdir -p '/data/plex/Library/Application Support'       
                ;;
        esac
    done
fi

echo "---------==---- AUTH SERVICES ----==---------"
echo " * ORGANIZR2 API"
echo L-- API documentation : ${ORGANIZR2_HTTP_URL_DEFAULT}/api/docs
echo " * ORGANIZR2 AUTH"
echo L-- manage service authorization : $([ "${ORGANIZR2_AUTHORIZATION}" = "ON" ] && echo "ON" || echo "OFF")

