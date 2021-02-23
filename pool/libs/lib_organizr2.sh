
# API ORGANIZR2------------------------
# API documentation http://organizr2.mydomain.com/api/docs/

# API v2
# get users
# http://organizr2.mydomain.com/api/v2/users
# {
#     "response": {
#         "result": "success",
#         "message": null,
#         "data": [
#             {
#                 "id": 1,
#                 "username": "xxxx",
#                 "password": "xxxxxxxxxx",
#                 "email": "xxxx@gmail.com",
#                 "plex_token": null,
#                 "group": "Admin",
#                 "group_id": 0,
#                 "locked": null,
#                 "image": "https://www.gravatar.com/avatar/e564570c599b871059233ccf80289c04?s=100&d=mm",
#                 "register_date": "2021-02-23T01:05:58Z",
#                 "auth_service": "internal"
#             }
#         ]
#     }
# }

# API v2
# get groups
# http://organizr2.mydomain.com/api/v2/groups
# {
#     "response": {
#         "result": "success",
#         "message": null,
#         "data": [
#             {
#                 "id": 1,
#                 "group": "Admin",
#                 "group_id": 0,
#                 "image": "plugins/images/groups/admin.png",
#                 "default": 0
#             },
#             {
#                 "id": 2,
#                 "group": "Co-Admin",
#                 "group_id": 1,
#                 "image": "plugins/images/groups/coadmin.png",
#                 "default": 0
#             },
#             {
#                 "id": 3,
#                 "group": "Super User",
#                 "group_id": 2,
#                 "image": "plugins/images/groups/superuser.png",
#                 "default": 0
#             },
#             {
#                 "id": 4,
#                 "group": "Power User",
#                 "group_id": 3,
#                 "image": "plugins/images/groups/poweruser.png",
#                 "default": 0
#             },
#             {
#                 "id": 5,
#                 "group": "User",
#                 "group_id": 4,
#                 "image": "plugins/images/groups/user.png",
#                 "default": 1
#             },
#             {
#                 "id": 6,
#                 "group": "Guest",
#                 "group_id": 999,
#                 "image": "plugins/images/groups/guest.png",
#                 "default": 0
#             }
#         ]
#     }
# }

# API v2
# get authorization by tab (a tab is a service in the point of view of tango)
# http://organizr2.mydomain.com/api/v2/tabs
# {
#     "response": {
#         "result": "success",
#         "message": null,
#         "data": {
#             "tabs": [
#                 {
#                     "id": 1,
#                     "order": 1,
#                     "category_id": 0,
#                     "name": "Settings",
#                     "url": "api/v2/page/settings",
#                     "url_local": null,
#                     "default": 0,
#                     "enabled": 1,
#                     "group_id": 1,
#                     "image": "fontawesome::cog",
#                     "type": 0,
#                     "splash": null,
#                     "ping": null,
#                     "ping_url": null,
#                     "timeout": null,
#                     "timeout_ms": null,
#                     "preload": null
#                 },
#                 {
#                     "id": 2,
#                     "order": 2,
#                     "category_id": 0,
#                     "name": "Homepage",
#                     "url": "api/v2/page/homepage",
#                     "url_local": null,
#                     "default": 1,
#                     "enabled": 1,
#                     "group_id": 4,
#                     "image": "fontawesome::home",
#                     "type": 0,
#                     "splash": null,
#                     "ping": null,
#                     "ping_url": null,
#                     "timeout": null,
#                     "timeout_ms": null,
#                     "preload": null
#                 }
#             ],
#             "categories": [
#                 {
#                     "id": 1,
#                     "order": 1,
#                     "category": "Unsorted",
#                     "category_id": 0,
#                     "image": "fontawesome::question",
#                     "default": 1
#                 }
#             ],
#             "groups": [
#                 {
#                     "id": 1,
#                     "group": "Admin",
#                     "group_id": 0,
#                     "image": "plugins/images/groups/admin.png",
#                     "default": 0
#                 },
#                 {
#                     "id": 2,
#                     "group": "Co-Admin",
#                     "group_id": 1,
#                     "image": "plugins/images/groups/coadmin.png",
#                     "default": 0
#                 },
#                 {
#                     "id": 3,
#                     "group": "Super User",
#                     "group_id": 2,
#                     "image": "plugins/images/groups/superuser.png",
#                     "default": 0
#                 },
#                 {
#                     "id": 4,
#                     "group": "Power User",
#                     "group_id": 3,
#                     "image": "plugins/images/groups/poweruser.png",
#                     "default": 0
#                 },
#                 {
#                     "id": 5,
#                     "group": "User",
#                     "group_id": 4,
#                     "image": "plugins/images/groups/user.png",
#                     "default": 1
#                 },
#                 {
#                     "id": 6,
#                     "group": "Guest",
#                     "group_id": 999,
#                     "image": "plugins/images/groups/guest.png",
#                     "default": 0
#                 }
#             ]
#         }
#     }
# }


# API v1
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
# hash table : give group id access for each service or subservices
declare -A ORGANIZR2_AUTH_GROUP_BY_SERVICE
# hash table : give group name for each group id
declare -A ORGANIZR2_AUTH_GROUP_NAME_BY_ID


__organizr2_api_url() {
    # NOTE http://localhost from inside organizr itself

    __o_api="/api/?v1"
    case $ORGANIZR2_API_VERSION in
        2 )
            __o_api="/api/v2"
        ;;
        1 )
            __o_api="/api/?v1"
        ;;
    esac

    export ORGANIZR2_INTERNAL_CONTAINER_API_URL="http://${ORGANIZR2_INSTANCE}${__o_api}"
    __tmp="${ORGANIZR2_INSTANCE^^}_HTTP_URL_DEFAULT_SECURE"
    export ORGANIZR2_API_URL="${!__tmp}${__o_api}"
}


__organizr2_init() {
    if $STELLA_API list_contains "${TANGO_SERVICES_ACTIVE}" "${ORGANIZR2_INSTANCE}"; then
        __organizr2_init_files
    fi
}




# declare variables
__organizr2_set_context() {

    # default organizr2 instance
    [ "$ORGANIZR2_INSTANCE" = "" ] && export ORGANIZR2_INSTANCE="organizr2"
    __add_declared_associative_array "ORGANIZR2_AUTH_GROUP_BY_SERVICE"
    __add_declared_associative_array "ORGANIZR2_AUTH_GROUP_NAME_BY_ID"
    
    __organizr2_api_url
    __add_declared_variables "ORGANIZR2_API_URL"
    __add_declared_variables "ORGANIZR2_INTERNAL_CONTAINER_API_URL"

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
        __tango_log "DEBUG" "organizr2" "Organizr2 authorization is enabled - organizr2 instance used : ${ORGANIZR2_INSTANCE}"
        if $STELLA_API list_contains "${TANGO_SERVICES_ACTIVE}" "${ORGANIZR2_INSTANCE}"; then
        
            if __is_docker_client_available; then
                if $(__container_is_healthy "${TANGO_APP_NAME}_${ORGANIZR2_INSTANCE}"); then
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



# install / update version
# organizr2 docker image have an auto update mechanism
# we disable it, and fully download the wanted version each time we init organizr2
# https://github.com/Organizr/docker-organizr/blob/master/root/etc/cont-init.d/40-install
__organizr2_init_files() {
    local __data_path="${ORGANIZR2_INSTANCE^^}_DATA_PATH"
    __data_path="${!__data_path}"
    local __branch_var="${ORGANIZR2_INSTANCE^^}_BRANCH"
    __branch="${!__branch_var}"
    local __commit="${ORGANIZR2_INSTANCE^^}_COMMIT"
    __commit="${!__commit}"

    # Use 'manual' as branch value to disable automatic code update at container launch
    # and have the hability to choose a specific commit
    local __manual_update_mode
    [ "${__branch}" = "manual" ] && __manual_update_mode="1"


    __tango_log "INFO" "organizr2" "Installing Organizr2 (instance : $ORGANIZR2_INSTANCE - branch version : $__branch - commit version : $__commit)"


    if [ "$__manual_update_mode" = "1" ]; then
        # remove organizr2 files
        rm -Rf ${__data_path}/www/organizr

        # override branch to v2-master to get organizr code source
        # if value was "manual" no code is downloaded
        eval export $__branch_var="v2-master"
    fi

    # install organizr2 files from scratch
    __service_down "$ORGANIZR2_INSTANCE" "NO_DELETE"
    __service_up "$ORGANIZR2_INSTANCE"
    # wait for files to be installed
    sleep 4
    __service_down "$ORGANIZR2_INSTANCE" "NO_DELETE"


    if [ "$__manual_update_mode" = "1" ]; then
        if [ ! "$__commit" = "" ]; then
            __tango_log "INFO" "organizr2" "Switching to Organizr commit $__commit"
            cd "${__data_path}/www/organizr"
            __tango_git checkout "${__commit}"
            # get last commit
            git rev-parse HEAD >"${__data_path}/www/organizr/Github.txt"
        fi

        # restore branch value
        eval export $__branch_var="$__branch"
    fi


    
}

# set permission on each service and subservice by syncing traefik and organizr2 api
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
        if $STELLA_API list_contains "${TANGO_SERVICES_ACTIVE}" "${ORGANIZR2_INSTANCE}"; then
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
    local __data_path="${ORGANIZR2_INSTANCE^^}_DATA_PATH"
    if [ "${ORGANIZR2_AUTHORIZATION}" = "ON" ]; then
        $STELLA_API crontab_add "* * * * * ${TANGO_APP_ROOT}/mambo auth sync 2>&1 > ${!__data_path}/cron.log" "$(id -un ${TANGO_USER_ID:-0})"
        $STELLA_API crontab_add "* * * * * sleep 30; ${TANGO_APP_ROOT}/mambo auth sync 2>&1 >> ${!__data_path}/cron.log" "$(id -un ${TANGO_USER_ID:-0})"
    else
        # TODO : if ORGANIZR2_INSTANCE name changed and crontab was active, this can not remove it
        $STELLA_API crontab_remove "* * * * * ${TANGO_APP_ROOT}/mambo auth sync 2>&1 > ${!__data_path}/cron.log" "$(id -un ${TANGO_USER_ID:-0})"
        $STELLA_API crontab_remove "* * * * * sleep 30; ${TANGO_APP_ROOT}/mambo auth sync 2>&1 >> ${!__data_path}/cron.log" "$(id -un ${TANGO_USER_ID:-0})"
    fi
}
__organizr2_scheduler_shutdown() {
    # TODO : if ORGANIZR2_INSTANCE name changed and crontab was active, this can not remove it
    local __data_path="${ORGANIZR2_INSTANCE^^}_DATA_PATH"
    $STELLA_API crontab_remove "* * * * * ${TANGO_APP_ROOT}/mambo auth sync 2>&1 > ${!__data_path}/cron.log" "$(id -un ${TANGO_USER_ID:-0})"
    $STELLA_API crontab_remove "* * * * * sleep 30; ${TANGO_APP_ROOT}/mambo auth sync 2>&1 >> ${!__data_path}/cron.log" "$(id -un ${TANGO_USER_ID:-0})"
}



# request organizr API
#       sample : __organizr2_api_request "GET" "tab/list"
# NOTE : API respond error if organizr2 is not yet configured in configuration panel
__organizr2_api_request() {
    local __result

    __result="$(__organizr2_api_launch_request "$1" "$2")"

    case "$__result" in
        *nginx*|*\<html\>*|"" )
        __tango_log "WARN" "organizr2" "API result : $__result";;
        *error* )
        __tango_log "ERROR" "organizr2" "API result : $__result"
        __tango_log "ERROR" "organizr2" "If error is invalid TOKEN API, then fix it in mambo.env file ORGANIZR2_API_TOKEN_PASSWORD variable"
        ;;
    esac

    echo $__result
}

__organizr2_api_launch_request() {
    local __http_command="$1"
    local __request="$2"

    local __token_password="${ORGANIZR2_INSTANCE^^}_API_TOKEN_PASSWORD"

    [ "${__http_command}" = "" ] && __http_command="GET"
    #docker run --network "${TANGO_APP_NETWORK_NAME}" --rm curlimages/curl:7.70.0 curl -X ${__http_command} -skL -H "token: ${!__token_password}" "${ORGANIZR2_INTERNAL_CONTAINER_API_URL}/${__request}"
    __tango_curl -X ${__http_command} -skL -H "token: ${!__token_password}" "${ORGANIZR2_INTERNAL_CONTAINER_API_URL}/${__request}"
}


# tabs name from organizr will be matched with docker compose service names. Ignoring case.
# If a docker compose service name (or a subservice) contains a "_", only the part after "_" will be used for a match
#           'Books' (organizr tab name) will match 'calibreweb_books' (docker compose service name)
# http://organizr2.mydomain.com/api/?v1/tab/list
# http://organizr2.mydomain.com/api/v2/tabs
__organizr2_auth_group_by_service_all() {
        case $ORGANIZR2_API_VERSION in
            1 ) 
                local __tab_list="$(__organizr2_api_request "GET" "tab/list")"
            ;;
            2 )
                local __tab_list="$(__organizr2_api_request "GET" "tabs")"               
            ;;
        esac

        local __group_id=
        local __tab_name=

        case "$__tab_list" in
            *nginx*|*\<html\>*|"" ) echo "$__tab_list";;
            *error* ) echo "$__tab_list"; return;;
            * )
                # get organizr tab name list
                case $ORGANIZR2_API_VERSION in
                    1 ) __tree=".data.tabs[]";;
                    2 ) __tree=".response.data.tabs[]";;
                esac
                for i in $(echo "$__tab_list" | jq -r ${__tree}' | .name + "#" + (.group_id|tostring)'); do

                    __group_id="${i//*#}"
                    __tab_name="${i//#*}"
                    __tab_name="${__tab_name,,}"

                    __found=0
                    for s in ${TANGO_SERVICES_ACTIVE} ${TANGO_SUBSERVICES_ROUTER}; do
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

        case $ORGANIZR2_API_VERSION in
            1 ) 
                local __user_list="$(__organizr2_api_request "GET" "user/list")"
                local __group_id=
                local __name=
                case "$__user_list" in
                    *nginx*|*\<html\>*|"" ) echo "$__user_list" ;;
                    *error* ) echo "$__user_list"; return;;
                    * )
                        for i in $(echo $__user_list | jq -r '.data.groups[] | .id'); do
                            __group_id="$(echo $__user_list | jq -r '.data.groups[] | select(.id=='$i') | (.group_id|tostring)')"
                            __name="$(echo $__user_list | jq -r '.data.groups[] | select(.id=='$i') | (.group|tostring)')"           
                            ORGANIZR2_AUTH_GROUP_NAME_BY_ID["${__group_id}"]="${__name}"
                        done
                    ;;
                esac
            ;;
            2 )
                local __group_list="$(__organizr2_api_request "GET" "groups")"
                local __group_id=
                local __name=
                case "$__group_list" in
                    *nginx*|*\<html\>*|"" ) echo "$__group_list" ;;
                    *error* ) echo "$__group_list"; return;;
                    * )
                        for i in $(echo $__group_list | jq -r '.response.data[] | .id'); do
                            __group_id="$(echo $__group_list | jq -r '.response.data[] | select(.id=='$i') | (.group_id|tostring)')"
                            __name="$(echo $__group_list | jq -r '.response.data[] | select(.id=='$i') | (.group|tostring)')"           
                            ORGANIZR2_AUTH_GROUP_NAME_BY_ID["${__group_id}"]="${__name}"
                        done
                    ;;
                esac
            ;;
        esac


}


# add traefik authentification system for all services
__organizr2_set_auth_service_all() {
    local __default_group="${1}"

    [ "${__default_group}" == "" ] && __default_group="999"
    local __group_id=
    for s in ${TANGO_SERVICES_ACTIVE} ${TANGO_SUBSERVICES_ROUTER}; do
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



# add traefik authentification system for a service to traefik API
__organizr2_traefik_api_set_auth_service() {
    local __service="$1"
    local __group_id="$2"


    local __midname="${__service}-auth"
    local __body=

    #__organizr2_api_url

    __traefik_api_rest_update '.http.middlewares.'\"${__midname}\"'.forwardauth.tls.insecureSkipVerify = true'

    case $ORGANIZR2_API_VERSION in
        1 )
            __traefik_api_rest_update '.http.middlewares.'\"${__midname}\"'.forwardauth.address = "'${ORGANIZR2_API_URL}'/auth&group='${__group_id}'"'
        ;;
        2 )
            __traefik_api_rest_update '.http.middlewares.'\"${__midname}\"'.forwardauth.address = "'${ORGANIZR2_API_URL}'/auth?group='${__group_id}'"'
        ;;
    esac
    
    __traefik_api_rest_update '.http.middlewares.'\"${__midname}\"'.forwardauth.trustforwardheader = true'
    # X-Organizr-User is the header returned by organizr when used
    __traefik_api_rest_update '.http.middlewares.'\"${__midname}\"'.forwardauth.authResponseHeaders = ["X-Organizr-User"]'


}


