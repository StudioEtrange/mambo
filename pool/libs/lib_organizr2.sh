

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


__organizr2_api_url() {
    # NOTE http://localhost from inside organizr itself
    ORGANIZR2_INTERNAL_CONTAINER_API_URL="http://organizr2/api/?v1"
    ORGANIZR2_API_URL="${ORGANIZR2_HTTP_URL_DEFAULT_SECURE}/api/?v1"
}
__organizr2_api_url

__organizr2_init() {
    if $STELLA_API list_contains "${TANGO_SERVICES_ACTIVE}" "organizr2"; then
        if $(__container_is_healthy "${TANGO_APP_NAME}_organizr2"); then
            # init ORGANIZR2_AUTH_GROUP_BY_SERVICE
            __organizr2_auth_group_by_service_all
            # init ORGANIZR2_AUTH_GROUP_NAME_BY_ID
            __organizr2_auth_group_name_by_id_all
            __organizr2_set_auth
        fi
    fi
}


__organizr2_set_auth() {
    if [ "${ORGANIZR2_AUTHORIZATION}" = "ON" ]; then
        # add traefik authentification system for all services to compose file
        __organizr2_set_auth_service_all
    fi
}


# TODO : migration to organizr2 api v2 https://docs.organizr.app/books/setup-features/page/api-v2-webserver-changes-needed





#       __organizr2_api_request "GET" "tab/list"
# NOTE : API respond error if organizr2 not yet setted
__organizr2_api_request() {
    __organizr2_api_url
    local __result="$(__organizr2_apiv1_request "$1" "$2")"
    case "$__result" in
        *nginx*|*html*|"" )
        echo "WARNING : API result : $__result";;
        *error* )
        echo "ERROR : API result : $__result"
        echo "If invalid TOKEN API fix it in mambo.env file ORGANIZR2_API_TOKEN_PASSWORD variable"
        ;;
    esac
    echo $__result

}

# request organizr2 API v1
__organizr2_apiv1_request() {
    local __http_command="$1"
    local __request="$2"
    
    [ "${__http_command}" = "" ] && __http_command="GET"
    docker run --network "${TANGO_APP_NETWORK_NAME}" --rm curlimages/curl:7.70.0 curl -X ${__http_command} -skL -H "token: ${ORGANIZR2_API_TOKEN_PASSWORD}" "${ORGANIZR2_INTERNAL_CONTAINER_API_URL}/${__request}"
}

# hash table : give group id access for each service
declare -A ORGANIZR2_AUTH_GROUP_BY_SERVICE
__add_declared_associative_array "ORGANIZR2_AUTH_GROUP_BY_SERVICE"
# http://organizr2.mydomain.com/api/?v1/tab/list
__organizr2_auth_group_by_service_all() {
    
        local __tab_list="$(__organizr2_api_request "GET" "tab/list")"
        local __group_id=
        local __service=

        case "$__tab_list" in
            *nginx*|*html*|"" ) echo "$__tab_list";;
            *error* ) echo "$__tab_list"; exit;;
            * )
                for i in $(echo "$__tab_list" | jq -r '.data.tabs[] | .name + "#" + (.group_id|tostring)'); do
                    __group_id="${i//*#}"
                    __service="${i//#*}"
                    ORGANIZR2_AUTH_GROUP_BY_SERVICE["${__service,,}"]="${__group_id}"
                done
            ;;
        esac
}

# hash table : give group name for each group id
declare -A ORGANIZR2_AUTH_GROUP_NAME_BY_ID
__add_declared_associative_array "ORGANIZR2_AUTH_GROUP_NAME_BY_ID"
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
    local __group_id=
    for s in ${TANGO_SERVICES_ACTIVE}; do
        __group_id="${ORGANIZR2_AUTH_GROUP_BY_SERVICE[${s}]}"
        [ ! "${__group_id}" = "" ] && __organizr2_set_auth_service "${s}" "${__group_id}"
    done
}

# add traefik authentification system for a service to compose file and to traefik API
__organizr2_set_auth_service() {
    local __service="$1"
    local __group_id="$2"

    # NOTE : dont need to update compose file
    #__organizr2_compose_add_auth_service "${__service}" "${__group_id}"
    __organizr2_traefik_api_set_auth_service "${__service}" "${__group_id}"
}


# add traefik authentification system for a service to compose file
# NOTE : NOT used, we do not set label into docker compose at each authorization change because we had to restart each updated services
__organizr2_compose_add_auth_service() {
    local __service="$1"
    local __group_id="$2"

    __organizr2_api_url

    yq w -i -- "${GENERATED_DOCKER_COMPOSE_FILE}" "services.${__service}.labels[+]" "traefik.http.middlewares.${__service}-auth.forwardauth.address=${ORGANIZR2_API_URL}/auth&group=${__group_id}"
    yq w -i -- "${GENERATED_DOCKER_COMPOSE_FILE}" "services.${__service}.labels[+]" "traefik.http.middlewares.${__service}-auth.forwardauth.tls.insecureSkipVerify=true"
    yq w -i -- "${GENERATED_DOCKER_COMPOSE_FILE}" "services.${__service}.labels[+]" "traefik.http.middlewares.${__service}-auth.forwardauth.trustforwardheader=true"
}



# TODO migrate organizr2 API v1 to v2
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
    

    # NOTE THIS URL should redirect after login to the wanted page
    ##https://media.chimere-harpie.org/?error=401&return=https://ombi.chimere-harpie.org/auth/cookie

    
}