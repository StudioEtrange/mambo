


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
    ORGANIZR2_INTERNAL_API_URL="http://organizr2/api" # (or http://localhost from inside organizr itself?)"
}


# request organizr2 API
#       __organizr2_api_request "GET" "tab/list"
__organizr2_api_request() {
    local __http_command="$1"
    local __request="$2"
    
    [ "${__http_command}" = "" ] && __http_command="GET"
    docker run --network "${TANGO_APP_NETWORK_NAME}" --rm curlimages/curl:7.70.0 curl -X ${__http_command} -skL -H "token: ${ORGANIZR2_API_TOKEN_PASSWORD}" "${ORGANIZR2_INTERNAL_API_URL}/?v1/${__request}"
}

# hash table : give group id access for each service
declare -A ORGANIZR2_AUTH_GROUP_BY_SERVICE
# http://organizr2.mydomain.com/api/?v1/tab/list
__organizr2_auth_group_by_service_all() {
    
    local __tab_list="$(__organizr2_api_request "GET" "tab/list")"

    local __group_id=
    local __service=
    for i in $(echo "$__tab_list" | jq -r '.data.tabs[] | .name + "#" + (.group_id|tostring)'); do
        __group_id="${i//*#}"
        __service="${i//#*}"
        ORGANIZR2_AUTH_GROUP_BY_SERVICE["${__service,,}"]="${__group_id}"
    done

}

# hash table : give group name for each group id
declare -A ORGANIZR2_AUTH_GROUP_NAME_BY_ID
__organizr2_auth_group_name_by_id_all() {

    #local __user_list="$(__organizr2_api_request "GET" "user/list")"
    local __group_id=
    local __name=
    for i in $(echo $__user_list | jq -r '.data.groups[] | .group + "#" + (.group_id|tostring)'); do
        __name="${i//*#}"
        __group_id="${i//#*}"
        ORGANIZR2_AUTH_GROUP_NAME_BY_ID["${__group_id}"]="${__name}"
    done
}

__organizr2_add_auth_service_all() {
    
    if [ "${ORGANIZR2_AUTHORIZATION}" = "ON" ]; then
        if $STELLA_API list_contains "${TANGO_SERVICES_ACTIVE}" "organizr2"; then
            local __group_id=
            for s in ${TANGO_SERVICES_ACTIVE}; do
                __group_id="${ORGANIZR2_AUTH_GROUP_BY_SERVICE[${s}]}"
                [ ! "$__group_id" = "" ] && __organizr2_add_auth_service "${s}" "${__group_id}"
            done
        fi
    fi

}

__organizr2_add_auth_service() {
    local __service="$1"
    local __group_id="$2"

	yq w -i -- "${GENERATED_DOCKER_COMPOSE_FILE}" "services.${__service}.labels[+]" "traefik.http.routers.${__service}.middlewares=${__service}-auth"
    yq w -i -- "${GENERATED_DOCKER_COMPOSE_FILE}" "services.${__service}.labels[+]" "traefik.http.routers.${__service}-secure.middlewares=${__service}-auth"

    yq w -i -- "${GENERATED_DOCKER_COMPOSE_FILE}" "services.${__service}.labels[+]" "traefik.http.middlewares.${__service}-auth.forwardauth.address=${ORGANIZR2_INTERNAL_API_URL}/?v1/auth&group=${__group_id}"
    yq w -i -- "${GENERATED_DOCKER_COMPOSE_FILE}" "services.${__service}.labels[+]" "traefik.http.middlewares.${__service}-auth.forwardauth.tls.insecureSkipVerify=true"
}




# CONTINUE HERE
__organizr2_traefik_api_set_auth_service() {
    local __service="$1"
    local __group_id="$2"


    local __midname="${__service}-auth"
    local __body=

    # create an auth middleware
    __body='
        {
            "http": { 
                "middlewares": {
                    "'${__midname}'" : {
                        "forwardauth" : {
                            "tls": {
                                "insecureSkipVerify": "true"
                            },
                            "address": "'${ORGANIZR2_INTERNAL_API_URL}'/?v1/auth&group='${__group_id}'"
                        }
                    }
                }
            }
        }
    '
    __traefik_api_request "PUT" "${__body}"

    # add auth middleware to service and service-secure routers
    __body='
        {
            "http": { 
                "routers": {
                    "'${__service}'" : {
                        "middlewares": [
                            "'${__midname}'"
                        ]          
                    },
                    "'${__service}'-secure" : {
                        "middlewares": [
                            "'${__midname}'"
                        ]          
                    }
                }
            }
        }
    '
    __traefik_api_request "PUT" "${__body}"
    
}