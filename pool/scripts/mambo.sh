#!/usr/bin/env bash

MODE="$1"
[ "${MODE}" = "" ] && MODE="info"

# rebuild organizr2 associative array
[ "${ORGANIZR2_AUTH_GROUP_BY_SERVICE}" = "" ] && declare -A ORGANIZR2_AUTH_GROUP_BY_SERVICE || eval declare -A ORGANIZR2_AUTH_GROUP_BY_SERVICE="${ORGANIZR2_AUTH_GROUP_BY_SERVICE}"
[ "${ORGANIZR2_AUTH_GROUP_NAME_BY_ID}" = "" ] && declare -A ORGANIZR2_AUTH_GROUP_NAME_BY_ID || eval declare -A ORGANIZR2_AUTH_GROUP_NAME_BY_ID="${ORGANIZR2_AUTH_GROUP_NAME_BY_ID}"

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
echo L-- manage mambo services authorization with organizr : $([ "${ORGANIZR2_AUTHORIZATION}" = "ON" ] && echo "ON" || echo "OFF")
echo "L-- organizr groups list by id"
[ ${#ORGANIZR2_AUTH_GROUP_NAME_BY_ID[@]} -gt 0 ] && printf "  + "
for i in "${!ORGANIZR2_AUTH_GROUP_NAME_BY_ID[@]}";do printf "%s : %s | " "$i" "${ORGANIZR2_AUTH_GROUP_NAME_BY_ID[$i]}";done; printf "\n";
echo "L-- services (equivalent to organizr tab) : group authorized (group id)"
for i in "${!ORGANIZR2_AUTH_GROUP_BY_SERVICE[@]}";do _gid="${ORGANIZR2_AUTH_GROUP_BY_SERVICE[$i]}"; printf "  + %s : %s (%s)\n" "$i" "${ORGANIZR2_AUTH_GROUP_NAME_BY_ID[$_gid]}" "${_gid}";done;


