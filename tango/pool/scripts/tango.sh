#!/usr/bin/env bash

MODE="$1"
[ "${MODE}" = "" ] && MODE="info"


echo "---------==---- INFO  ----==---------"
echo "* Tango current app name : ${TANGO_APP_NAME}"
echo "L-- standalone app : $([ "${TANGO_NOT_IN_APP}" = "1" ] && echo NO || echo YES)"
echo "L-- instance mode : ${TANGO_INSTANCE_MODE}"
echo "L-- tango root : ${TANGO_ROOT}"
echo "L-- tango env file : ${TANGO_ENV_FILE}"
echo "L-- tango compose file : ${TANGO_COMPOSE_FILE}"
echo "L-- app root : ${TANGO_APP_ROOT}"
echo "L-- app env file : ${TANGO_APP_ENV_FILE}"
echo "L-- app compose file : ${TANGO_APP_COMPOSE_FILE}"
echo "L-- user env file : ${TANGO_USER_ENV_FILE}"
echo "L-- user compose file : ${TANGO_USER_COMPOSE_FILE}"
echo "---------==---- INFO SERVICES ----==---------"
echo "* Available services : ${TANGO_SERVICES_AVAILABLE}"
for service in ${TANGO_SERVICES_AVAILABLE}; do
    service="${service^^}"
    version="${service}_VERSION"
    version="${!version}"
    
    echo "* ${service}"
    if [[ " ${TANGO_SERVICES_DISABLED} " =~ .*\ ${service,,}\ .* ]]; then
        echo "L-- status : DISABLED"
    else
        echo "L-- status : ENABLED"
    fi
   
    # filter information to show
    case ${service} in
        VPN ) info_extended=0; info_variables=0;;
        * ) info_extended=1; info_variables=1;;
    esac

    if [ "${info_extended}" = "1" ]; then
        echo "L-- version : ${version}"
        
        __var="${service}_ENTRYPOINTS"; __entrypoints="${!__var}"; __var="${service}_ENTRYPOINTS_SECURE"; __entrypoints="${__entrypoints} ${!__var}";
        # trim __entrypoints
        __entrypoints="${__entrypoints#"${__entrypoints%%[![:space:]]*}"}"   # remove leading whitespace characters
        __entrypoints="${__entrypoints%"${var##*[![:space:]]}"}" # remove trailing whitespace characters
        echo "L-- entrypoints : ${__entrypoints}"
        
        echo -n "L-- use letsencrypt : "
        __letsencrypt=
        for s in ${LETS_ENCRYPT_SERVICES}; do
            [ "${service,,}" = "$s" ] && __letsencrypt=1
        done
        [ "${__letsencrypt}" = "1" ] && echo YES || echo NO

        echo -n "L-- redirect HTTP to HTTPS : "
        __redirected=
        for s in ${NETWORK_SERVICES_REDIRECT_HTTPS}; do
            [ "${service,,}" = "$s" ] && __redirected=1
        done
        [ "${__redirected}" = "1" ] && echo YES || echo NO
        
        __direct_access="${service}_DIRECT_ACCESS_PORT"; __direct_access="${!__direct_access}";
        echo "L-- direct access port : ${__direct_access}"

        __urls=
        __urls_api_get=
        __urls_api_data=
        __urls_api_rest=
        for u in $(compgen -A variable | grep -Ev DEFAULT | grep ^${service}_HTTP_URL_); do
            __urls="${__urls} ${!u}"
            __urls_api_get="${__urls_api_get} ${!u}/api"
            __urls_api_data="${__urls_api_data} ${!u}/api/rawdata"
            __urls_api_rest="${__urls_api_rest} ${!u}/api/providers/rest"
        done

        __var="${service^^}_HOSTNAME"
        __hostname="${!__var}"
        if [ ! "${__entrypoints}" = "" ]; then
            echo "L-- URLs : ${__urls}"
            if [ "${service^^}" = "TRAEFIK" ]; then
                echo "L -- API GET endpoint : ${__urls_api_get}"
                echo "L -- API GET all data : ${__urls_api_data}"
                echo "L -- API PUT (REST API) : ${__urls_api_rest}"
            fi
            # NOTE crt.sh do not need domain to be reacheable from internet : it is a search engine for certificate
            echo "L-- certificate status : https://crt.sh/?q=${__hostname}"
            [ "${NETWORK_INTERNET_EXPOSED}" = "1" ] && echo "L-- diagnostic dns, cert, content : https://check-your-website.server-daten.de/?q=${__domain}"
        fi
    fi
    if [ "${info_variables}" = "1" ]; then
        echo "L-- variables list :"
        for variables in $(compgen -A variable | grep ^${service}_); do
            case ${variables} in
                *PASSWORD|*AUTH ) echo "  + ${variables}=*****";;
                * ) echo "  + ${variables}=${!variables}";;
            esac
        done
    fi

done

echo "---------==---- MODULES ----==---------"
echo "* Active modules as a service "
echo "L-- a module is a predefined service"
echo "L-- format : <module>[@<network area>][%<service dependency1>][%<service dependency2>][^<vpn id>]"
echo "L-- list : ${TANGO_SERVICES_MODULES_FULL}"
echo "* Available Tango Modules"
echo "L-- tango modules root : [${TANGO_MODULES_ROOT}]"
echo "L-- tango modules list : ${TANGO_MODULES_AVAILABLE}"
echo "* Available App Modules"
echo "L-- app modules root : [${TANGO_APP_MODULES_ROOT}]"
echo "L-- app modules list : ${TANGO_APP_MODULES_AVAILABLE}"



echo "---------==---- PLUGINS ----==---------"
echo "* Active plugins infos"
echo "L-- a plugin act on a service"
echo "L-- format : <plugin>[%<auto exec at launch into service1>][%!<manual exec into service2>][#arg1][#arg2]"
echo "L-- list : ${TANGO_PLUGINS_FULL}"
echo "* Available Tango plugins"
echo "L-- tango plugins root : [${TANGO_PLUGINS_ROOT}] {/pool/tango/plugins}"
echo "L-- tango plugins list : ${TANGO_PLUGINS_AVAILABLE}"
echo "* Available App plugins"
echo "L-- app plugins root : [${TANGO_APP_PLUGINS_ROOT}] {/pool/${TANGO_APP_NAME}/plugins}"
echo "L-- app plugins list : ${TANGO_APP_PLUGINS_AVAILABLE}"


echo "---------==---- SERVICES CERTIFICATES ----==---------"
echo "* Let's encrypt"
echo -n "L-- status : "
case ${LETS_ENCRYPT} in
    enable ) echo ENABLED;;
    debug ) echo ENABLED with DEBUG lets encrypt server;;
    * ) echo DISABLED;;
esac

echo "L-- email used : $LETS_ENCRYPT_MAIL"
echo "L-- certificates generated for : $LETS_ENCRYPT_SERVICES"
echo "L-- challenge method : $LETS_ENCRYPT_CHALLENGE"
echo "* Provided certificates"
echo "L-- traefik tls conf : ${GENERATED_TLS_FILE}"
echo "L-- cert files : ${TANGO_CERT_FILES}"
echo "L-- key files : ${TANGO_KEY_FILES}"


echo "---------==---- NETWORK ----==---------"
echo "* IP & Domain"
echo L-- Declared domain : "$TANGO_DOMAIN"
echo -n "L-- Should be reached from internet : "
[ "${NETWORK_INTERNET_EXPOSED}" = "1" ] && echo YES || echo NO
echo L-- External IP from internet : $TANGO_EXTERNAL_IP
echo L-- Host name : $TANGO_HOSTNAME
echo L-- Host default local IP : $TANGO_HOST_DEFAULT_IP
echo L-- Host local IPs : $TANGO_HOST_IP
echo L-- Random free ports mode :  $([ "${TANGO_FREEPORT_MODE}" = "1" ] && echo "ON [$GENERATED_ENV_FILE_FREEPORT]" || echo "OFF")
echo "* MAIN AREA"
echo L-- services : $NETWORK_SERVICES_AREA_MAIN
echo L-- HTTP entrypoint [web_main] - port : $NETWORK_PORT_MAIN reachable from internet : $([ "${NETWORK_PORT_MAIN_REACHABLE}" = "1" ] && echo YES || echo dont know)
echo L-- HTTPS entrypoint [web_main_secure] - port : $NETWORK_PORT_MAIN_SECURE reachable from internet : $([ "${NETWORK_PORT_MAIN_SECURE_REACHABLE}" = "1" ] && echo YES || echo dont know)
echo "* SECONDARY AREA"
echo L-- services : $NETWORK_SERVICES_AREA_SECONDARY
echo L-- HTTP entrypoint [web_secondary] - port : $NETWORK_PORT_SECONDARY reachable from internet : $([ "${NETWORK_PORT_SECONDARY_REACHABLE}" = "1" ] && echo YES || echo dont know)
echo L-- HTTPS entrypoint [web_secondary_secure] - port : $NETWORK_PORT_SECONDARY_SECURE reachable from internet : $([ "${NETWORK_PORT_SECONDARY_SECURE_REACHABLE}" = "1" ] && echo YES || echo dont know)
echo "* ADMIN AREA"
echo L-- services : $NETWORK_SERVICES_AREA_ADMIN
echo L-- HTTP entrypoint [web_admin] - port : $NETWORK_PORT_ADMIN reachable from internet : $([ "${NETWORK_PORT_ADMIN_REACHABLE}" = "1" ] && echo YES || echo dont know)
echo L-- HTTPS entrypoint [web_admin_secure] - port : $NETWORK_PORT_ADMIN_SECURE reachable from internet : $([ "${NETWORK_PORT_ADMIN_SECURE_REACHABLE}" = "1" ] && echo YES || echo dont know)

echo "---------==---- VPN ----==---------"
echo "* VPN Service"
echo "L-- vpn list : ${VPN_SERVICES_LIST}"
echo "L-- check dns leaks :  https://dnsleaktest.com/"
echo "* VPN Infos"
for v in ${VPN_SERVICES_LIST}; do
    echo "L-- vpn id : ${v}"
    for var in $(compgen -A variable | grep ^${v^^}_); do
        case ${var} in
            *PASSWORD*|*AUTH* ) echo "  + ${var}=*****";;
            * ) echo "  + ${var}=${!var}";;
        esac
    done
done




echo "---------==---- PATHS ----==---------"
echo Format : [host path] is mapped to {inside container path}
echo App data path : [$APP_DATA_PATH] is mapped to {/data}
echo Data path of app plugins : [$PLUGINS_DATA_PATH] is mapped to {/plugins_data}
echo Data path of internal tango data : [$TANGO_DATA_PATH] is mapped to {/internal_data}
echo Artefact folders : [$TANGO_ARTEFACT_FOLDERS] are mapped to {${TANGO_ARTEFACT_MOUNT_POINT:-/artefact}} subfolders
echo Lets encrypt store file : [$TANGO_DATA_PATH/letsencrypt/acme.json] {/internal_data/letsencrypt/acme.json}
[ "${MODE}" = "init" ] && chmod 600 /internal_data/letsencrypt/acme.json
echo Traefik dynamic conf files directory [$TANGO_DATA_PATH/traefikconfig] {/internal_data/traefikconfig}
