
# API ORGANIZR2------------------------
# API documentation http://organizr2.mydomain.com/api/docs/



# get user and group list 
# http://organizr2.mydomain.com/api/?v1/user/list

#     "request": "v1\/user\/list",
#     "params": [],
#     "status": "success",
#     "statusText": "success",
#     "data": {
#         "users": [
#             {
#                 "id": 1,
#                 "username": "xxxx",
#                 "email": "xxxx@gmail.com",
#                 "plex_token": null,
#                 "group": "Admin",
#                 "group_id": 0,
#                 "locked": null,
#                 "image": "https:\/\/www.gravatar.com\/avatar\/e564570c599b871059233ccf80289c04?s=100&d=mm",
#                 "register_date": "2020-06-01T22:43:38Z",
#                 "auth_service": "internal"
#             }
#         ],
#         "groups": [
#             {
#                 "id": 1,
#                 "group": "Admin",
#                 "group_id": 0,
#                 "image": "plugins\/images\/groups\/admin.png",
#                 "default": 0
#             },
#             {
#                 "id": 2,
#                 "group": "Co-Admin",
#                 "group_id": 1,
#                 "image": "plugins\/images\/groups\/coadmin.png",
#                 "default": 0
#             },
#             {
#                 "id": 3,
#                 "group": "Super User",
#                 "group_id": 2,
#                 "image": "plugins\/images\/groups\/superuser.png",
#                 "default": 0
#             },
#             {
#                 "id": 4,
#                 "group": "Power User",
#                 "group_id": 3,
#                 "image": "plugins\/images\/groups\/poweruser.png",
#                 "default": 0
#             },
#             {
#                 "id": 5,
#                 "group": "User",
#                 "group_id": 4,
#                 "image": "plugins\/images\/groups\/user.png",
#                 "default": 1
#             },
#             {
#                 "id": 6,
#                 "group": "Guest",
#                 "group_id": 999,
#                 "image": "plugins\/images\/groups\/guest.png",
#                 "default": 0
#             }
#         ]
#     },
#     "generationDate": "2020-06-03T01:05:15Z",
#     "generationTime": "32.5ms"
# }



# get authorization by tab (a tab is a service in the point of view of tango)
# http://organizr2.mydomain.com/api/?v1/tab/list

# {
#     "request": "v1\/tab\/list",
#     "params": [],
#     "status": "success",
#     "statusText": "success",
#     "data": {
#         "tabs": [
#             {
#                 "id": 1,
#                 "order": 1,
#                 "category_id": 0,
#                 "name": "Settings",
#                 "url": "api\/?v1\/settings\/page",
#                 "url_local": null,
#                 "default": 0,
#                 "enabled": 1,
#                 "group_id": 1,
#                 "image": "fontawesome::cog",
#                 "type": 0,
#                 "splash": null,
#                 "ping": null,
#                 "ping_url": null,
#                 "timeout": null,
#                 "timeout_ms": null,
#                 "preload": null
#             },
#             {
#                 "id": 2,
#                 "order": 2,
#                 "category_id": 0,
#                 "name": "Homepage",
#                 "url": "api\/?v1\/homepage\/page",
#                 "url_local": null,
#                 "default": 0,
#                 "enabled": 0,
#                 "group_id": 4,
#                 "image": "fontawesome::home",
#                 "type": 0,
#                 "splash": null,
#                 "ping": null,
#                 "ping_url": null,
#                 "timeout": null,
#                 "timeout_ms": null,
#                 "preload": null
#             },
#             {
#                 "id": 3,
#                 "order": 3,
#                 "category_id": 0,
#                 "name": "Ombi",
#                 "url": "https:\/\/ombi.chimere-harpie.org:8443",
#                 "url_local": "",
#                 "default": 0,
#                 "enabled": 1,
#                 "group_id": 1,
#                 "image": "plugins\/images\/tabs\/ombi-plex.png",
#                 "type": 1,
#                 "splash": null,
#                 "ping": null,
#                 "ping_url": "",
#                 "timeout": "null",
#                 "timeout_ms": 0,
#                 "preload": null
#             }
#         ],
#         "categories": [
#             {
#                 "id": 1,
#                 "order": 1,
#                 "category": "Unsorted",
#                 "category_id": 0,
#                 "image": "plugins\/images\/categories\/unsorted.png",
#                 "default": 1
#             }
#         ],
#         "groups": [
#             {
#                 "id": 1,
#                 "group": "Admin",
#                 "group_id": 0,
#                 "image": "plugins\/images\/groups\/admin.png",
#                 "default": 0
#             },
#             {
#                 "id": 2,
#                 "group": "Co-Admin",
#                 "group_id": 1,
#                 "image": "plugins\/images\/groups\/coadmin.png",
#                 "default": 0
#             },
#             {
#                 "id": 3,
#                 "group": "Super User",
#                 "group_id": 2,
#                 "image": "plugins\/images\/groups\/superuser.png",
#                 "default": 0
#             },
#             {
#                 "id": 4,
#                 "group": "Power User",
#                 "group_id": 3,
#                 "image": "plugins\/images\/groups\/poweruser.png",
#                 "default": 0
#             },
#             {
#                 "id": 5,
#                 "group": "User",
#                 "group_id": 4,
#                 "image": "plugins\/images\/groups\/user.png",
#                 "default": 1
#             },
#             {
#                 "id": 6,
#                 "group": "Guest",
#                 "group_id": 999,
#                 "image": "plugins\/images\/groups\/guest.png",
#                 "default": 0
#             }
#         ]
#     },
#     "generationDate": "2020-06-03T01:10:53Z",
#     "generationTime": "29.9ms"
# }

# global variables - init at phase PREPARE ACTION before loading env files
# hash table : give group id access for each service
declare -A ORGANIZR2_AUTH_GROUP_BY_SERVICE
# hash table : give group name for each group id
declare -A ORGANIZR2_AUTH_GROUP_NAME_BY_ID

# TODO migrate to apiv2
#ORGANIZR2_INTERNAL_CONTAINER_API_URL="http://organizr2/api/v2"
#ORGANIZR2_API_URL="${O3_HTTP_URL_DEFAULT_SECURE}/api/v2"
__organizr2_api_url() {
    # NOTE http://localhost from inside organizr itself
    ORGANIZR2_INTERNAL_CONTAINER_API_URL="http://organizr2/api/?v1"
    ORGANIZR2_API_URL="${ORGANIZR2_HTTP_URL_DEFAULT_SECURE}/api/?v1"
}
__organizr2_api_url






# declare variables
__organizr2_set_context() {
    __add_declared_associative_array "ORGANIZR2_AUTH_GROUP_BY_SERVICE"
    __add_declared_associative_array "ORGANIZR2_AUTH_GROUP_NAME_BY_ID"
    

    # init auth group by requesting organizr2 and load current permissions
    export ORGANIZR2_DEFAULT_GROUP=
    __add_declared_variables "ORGANIZR2_DEFAULT_GROUP"

    if [ "${ORGANIZR2_AUTHORIZATION}" = "OFF" ]; then
        __tango_log "DEBUG" "organizr2" "Organizr2 authorization system is disabled"
      
        # for already running service with an attached auth@rest middleware, disable any restriction
        # use Guest group (999) with empty global array variable
        declare -A ORGANIZR2_AUTH_GROUP_BY_SERVICE=
        declare -A ORGANIZR2_AUTH_GROUP_NAME_BY_ID=

    fi

    if [ "${ORGANIZR2_AUTHORIZATION}" = "ON" ]; then
        __tango_log "DEBUG" "organizr2" "Organizr2 authorization is enabled"
        if $STELLA_API list_contains "${TANGO_SERVICES_ACTIVE}" "organizr2"; then
            if __is_docker_client_available; then
                if $(__container_is_healthy "${TANGO_APP_NAME}_organizr2"); then
                    # init ORGANIZR2_AUTH_GROUP_BY_SERVICE
                    __organizr2_auth_group_by_service_all
                    # init ORGANIZR2_AUTH_GROUP_NAME_BY_ID
                    __organizr2_auth_group_name_by_id_all

                    # by default authorize service not defined as an organizr tab to everybody - use Guest group (999)
                    ORGANIZR2_DEFAULT_GROUP="999"
                else
                    # organizr2 is not yet healthy, so global array variable (ORGANIZR2_AUTH_GROUP_BY_SERVICE and ORGANIZR2_AUTH_GROUP_NAME_BY_ID) might not yet setted
                    # so block everybody not admin - use Admin group (0)
                    ORGANIZR2_DEFAULT_GROUP="0"
                fi
            else
                __tango_log "WARN" "organizr2" "docker-cli unavailable"
                # TODO docker client not available ? is there a problem ? are we outside docker ? does this really occurs ?
                # block everybody not admin - use Admin group (0)
                ORGANIZR2_DEFAULT_GROUP="0"
            fi
        else
            # no middleware will be created and all service will be accessible
            __tango_log "WARN" "organizr2" "Organizr2 is not declared as an active service in TANGO_SERVICES_ACTIVE dispite the fact that ORGANIZR2_AUTHORIZATION is ON"
        fi
    fi

}


# set permission on each service by syncing traefik and organizr2 api
# in PRINT mode - show some output
__organizr2_auth() {
    local __mode="$1"

    [ "$__mode" = "" ] && __mode="PRINT"

    if [ "${ORGANIZR2_AUTHORIZATION}" = "OFF" ]; then
        if [ "${__mode}" = "PRINT" ]; then
            echo " * ORGANIZR2 AUTH"
            echo "L-- manage mambo services authorization with organizr : OFF"
        fi

        # if organizr2 is not active nor healthy the middleware will be ignored which is perfect here
        __organizr2_set_auth_service_all "$ORGANIZR2_DEFAULT_GROUP"
    fi

    if [ "${ORGANIZR2_AUTHORIZATION}" = "ON" ]; then
        if $STELLA_API list_contains "${TANGO_SERVICES_ACTIVE}" "organizr2"; then
            if [ "${__mode}" = "PRINT" ]; then
                echo " * ORGANIZR2 AUTH"
                echo L-- manage mambo services authorization with organizr : $([ "${ORGANIZR2_AUTHORIZATION}" = "ON" ] && echo "ON" || echo "OFF")
                echo "L-- organizr groups list by id"
                [ ${#ORGANIZR2_AUTH_GROUP_NAME_BY_ID[@]} -gt 0 ] && printf "  + "
                for i in "${!ORGANIZR2_AUTH_GROUP_NAME_BY_ID[@]}";do printf "%s : %s | " "$i" "${ORGANIZR2_AUTH_GROUP_NAME_BY_ID[$i]}";done; printf "\n";
                echo "L-- services (equivalent to organizr tab) : group authorized (group id)"
                for i in "${!ORGANIZR2_AUTH_GROUP_BY_SERVICE[@]}";do _gid="${ORGANIZR2_AUTH_GROUP_BY_SERVICE[$i]}"; printf "  + %s : %s (%s)\n" "$i" "${ORGANIZR2_AUTH_GROUP_NAME_BY_ID[$_gid]}" "${_gid}";done;
            fi
            __organizr2_set_auth_service_all "$ORGANIZR2_DEFAULT_GROUP"
        fi
    fi
}


# manage crontab job
# launched each 30 seconds
__organizr2_scheduler_set() {
    if [ "${ORGANIZR2_AUTHORIZATION}" = "ON" ]; then
        $STELLA_API crontab_add "* * * * * ${TANGO_APP_ROOT}/mambo auth sync 2>&1 > ${ORGANIZR2_DATA_PATH}/cron.log" "$(id -un ${TANGO_USER_ID:-0})"
        $STELLA_API crontab_add "* * * * * sleep 30; ${TANGO_APP_ROOT}/mambo auth sync 2>&1 >> ${ORGANIZR2_DATA_PATH}/cron.log" "$(id -un ${TANGO_USER_ID:-0})"
    else
        $STELLA_API crontab_remove "* * * * * ${TANGO_APP_ROOT}/mambo auth sync 2>&1 > ${ORGANIZR2_DATA_PATH}/cron.log" "$(id -un ${TANGO_USER_ID:-0})"
        $STELLA_API crontab_remove "* * * * * sleep 30; ${TANGO_APP_ROOT}/mambo auth sync 2>&1 >> ${ORGANIZR2_DATA_PATH}/cron.log" "$(id -un ${TANGO_USER_ID:-0})"
    fi
}
__organizr2_scheduler_shutdown() {
    $STELLA_API crontab_remove "* * * * * ${TANGO_APP_ROOT}/mambo auth sync 2>&1 > ${ORGANIZR2_DATA_PATH}/cron.log" "$(id -un ${TANGO_USER_ID:-0})"
    $STELLA_API crontab_remove "* * * * * sleep 30; ${TANGO_APP_ROOT}/mambo auth sync 2>&1 >> ${ORGANIZR2_DATA_PATH}/cron.log" "$(id -un ${TANGO_USER_ID:-0})"
}



# TODO : migration to organizr2 api v2 https://docs.organizr.app/books/setup-features/page/api-v2-webserver-changes-needed
# __organizr2_api_request "GET" "tab/list"
# NOTE : API respond error if organizr2 not yet setted in configuration panel
__organizr2_api_request() {
    __organizr2_api_url
    local __result="$(__organizr2_apiv1_request "$1" "$2")"
    case "$__result" in
        *nginx*|*html*|"" )
        __tango_log "WARN" "organizr2" "API result : $__result";;
        *error* )
        __tango_log "ERROR" "organizr2" "API result : $__result"
        __tango_log "ERROR" "organizr2" "If error is invalid TOKEN API, then fix it in mambo.env file ORGANIZR2_API_TOKEN_PASSWORD variable"
        ;;
    esac
    echo $__result

}

# request organizr2 API v1
__organizr2_apiv1_request() {
    local __http_command="$1"
    local __request="$2"
    
    [ "${__http_command}" = "" ] && __http_command="GET"
    #docker run --network "${TANGO_APP_NETWORK_NAME}" --rm curlimages/curl:7.70.0 curl -X ${__http_command} -skL -H "token: ${ORGANIZR2_API_TOKEN_PASSWORD}" "${ORGANIZR2_INTERNAL_CONTAINER_API_URL}/${__request}"
    __tango_curl -X ${__http_command} -skL -H "token: ${ORGANIZR2_API_TOKEN_PASSWORD}" "${ORGANIZR2_INTERNAL_CONTAINER_API_URL}/${__request}"
}


# tabs name from organizr will be matched with docker compose service names. Ignoring case.
# If a docker compose service name contains a "_", only the part after "_" will be used for a match
#           'Books' (organizr tab name) will match 'calibreweb_boobs' (docker compose service name)
# http://organizr2.mydomain.com/api/?v1/tab/list
__organizr2_auth_group_by_service_all() {
    
        local __tab_list="$(__organizr2_api_request "GET" "tab/list")"
        local __group_id=
        local __tab_name=

        case "$__tab_list" in
            *nginx*|*html*|"" ) echo "$__tab_list";;
            *error* ) echo "$__tab_list"; exit;;
            * )
                # get organizr tab name list
                for i in $(echo "$__tab_list" | jq -r '.data.tabs[] | .name + "#" + (.group_id|tostring)'); do
                    __group_id="${i//*#}"
                    __tab_name="${i//#*}"
                    __tab_name="${__tab_name,,}"

                    __found=0
                    for s in ${TANGO_SERVICES_ACTIVE}; do
                        # try to match tab name with a service name
                        case $s in
                            ${__tab_name} ) 
                                __tango_log "DEBUG" "organizr2" "Matching organizr tab name : ${__tab_name} with service : ${s}"
                                __found=1
                                ;;
                        esac
                        [ "$__found" = "1" ] && break;
                        # try to match tab name with a composed service name like "calibre_books"
                        if $STELLA_API string_contains "${s}" "_"; then
                            case $s in
                                *_${__tab_name} ) 
                                    __tango_log "DEBUG" "organizr2" "Matching organizr tab name : ${__tab_name} with service : ${s}"
                                    __tab_name="${s}"
                                    __found=1
                                    ;;
                            esac
                        fi
                        [ "$__found" = "1" ] && break;
                    done
                    
                    ORGANIZR2_AUTH_GROUP_BY_SERVICE["${__tab_name}"]="${__group_id}"
                done
            ;;
        esac
}


__organizr2_auth_group_name_by_id_all() {
        local __user_list="$(__organizr2_api_request "GET" "user/list")"
        local __group_id=
        local __name=
        case "$__user_list" in
            *nginx*|*html*|"" ) echo "$__user_list" ;;
            *error* ) echo "$__user_list"; exit;;
            * )
                for i in $(echo $__user_list | jq -r '.data.groups[] | .id'); do
                    __group_id="$(echo $__user_list | jq -r '.data.groups[] | select(.id=='$i') | (.group_id|tostring)')"
                    __name="$(echo $__user_list | jq -r '.data.groups[] | select(.id=='$i') | (.group|tostring)')"           
                    ORGANIZR2_AUTH_GROUP_NAME_BY_ID["${__group_id}"]="${__name}"
                done
            ;;
        esac
}


# add traefik authentification system for all services
__organizr2_set_auth_service_all() {
    local __default_group="${1}"

   
    [ "${__default_group}" == "" ] && __default_group="999"
    local __group_id=
    for s in ${TANGO_SERVICES_ACTIVE}; do
        __group_id="${ORGANIZR2_AUTH_GROUP_BY_SERVICE[${s}]}"
        if [ "${__group_id}" = "" ]; then 
            # this service have not any authorised group to protect it - so use default
            # even if the service will not used this created forwardauth middleware (ie : a useless traefik-auth@rest middleware will be created)
            __organizr2_traefik_api_set_auth_service "${s}" "${__default_group}"
        else
            __organizr2_traefik_api_set_auth_service "${s}" "${__group_id}"
        fi
    done
}




# TODO migrate organizr2 API v1 to v2
#__traefik_api_rest_update '.http.middlewares.'\"${__midname}\"'.forwardauth.address = "'${ORGANIZR2_API_URL}'/auth?group='${__group_id}'"'
# add traefik authentification system for a service to traefik API
__organizr2_traefik_api_set_auth_service() {
    local __service="$1"
    local __group_id="$2"


    local __midname="${__service}-auth"
    local __body=

    __organizr2_api_url

    __traefik_api_rest_update '.http.middlewares.'\"${__midname}\"'.forwardauth.tls.insecureSkipVerify = true'
    #__traefik_api_rest_update '.http.middlewares.'\"${__midname}\"'.forwardauth.address = "'${ORGANIZR2_INTERNAL_CONTAINER_API_URL}'/auth&group='${__group_id}'"'
    __traefik_api_rest_update '.http.middlewares.'\"${__midname}\"'.forwardauth.address = "'${ORGANIZR2_API_URL}'/auth&group='${__group_id}'"'
    __traefik_api_rest_update '.http.middlewares.'\"${__midname}\"'.forwardauth.trustforwardheader = true'
    # X-Organizr-User is the header returned by organizr when used
    __traefik_api_rest_update '.http.middlewares.'\"${__midname}\"'.forwardauth.authResponseHeaders = ["X-Organizr-User"]'

    # NOTE THIS URL should redirect after authentification done by organizr to the original wanted page but seems to not work with traefik
    ##https://media.chimere-harpie.org/?error=401&return=https://ombi.chimere-harpie.org/auth/cookie

}


