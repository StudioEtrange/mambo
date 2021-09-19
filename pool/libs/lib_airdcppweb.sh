

# FUNCTION USED INSIDE PLUGIN
# WAIT for airdcpp service up
__airdcpp_set_port() {
    # TODO CONTINUE HERE
    local new_port="$1"
    
    TRANSMISSION_DATA_HOME="/config"
    transmission_username="${TRANSMISSION_USER}"
    transmission_passwd="${TRANSMISSION_PASSWORD}"
    transmission_settings_file="${TRANSMISSION_DATA_HOME}/settings.json"

    # Check if transmission remote is set up with authentication
    auth_enabled=$(grep 'rpc-authentication-required\"' "$transmission_settings_file" \
                    | grep -oE 'true|false')
    if [[ "true" = "$auth_enabled" ]]
    then
    echo "  + transmission auth required"
    myauth="--auth $transmission_username:$transmission_passwd"
    else
        echo "  + transmission auth not required"
        myauth=""
    fi

    # make sure transmission is running and accepting requests
    echo "  + waiting for transmission to become responsive"
    until torrent_list="$(transmission-remote $myauth -l)"; do sleep 10; done
    echo "  + transmission became responsive"
    output="$(echo "  + $torrent_list" | tail -n 2)"
    echo "  + $output"

    # get current listening port
    transmission_peer_port=$(transmission-remote $myauth -si | grep Listenport | grep -oE '[0-9]+')
    if [[ "$new_port" != "$transmission_peer_port" ]]; then
        echo "  + setting transmission port to $new_port"
        transmission-remote ${myauth} -p "$new_port"

        echo "  + Checking port..."
        sleep 10
        transmission-remote ${myauth} -pt
    else
        echo "  + No action needed, port hasn't changed"
    fi
}


# -----------------------------------------------------------------------------------------
# declare variables
__airdcppweb_set_context() {
    export AIRDCPPWEB_CFG_PATH="$AIRDCPPWEB_DATA_PATH/DCPlusPlus.xml"
    __add_declared_variables "AIRDCPPWEB_CFG_PATH"

    export AIRDCPPWEB_AUTH_ENABLED=
    __add_declared_variables "AIRDCPPWEB_AUTH_ENABLED"

    # airdcpp always require to be authentified
    AIRDCPPWEB_AUTH_ENABLED="true"
     [ "$AIRDCPPWEB_AUTH_ENABLED" = "true" ] && __tango_log "DEBUG" "airdcppweb" "Airdcpp auth is enabled"


    # export AIRDCPPWEB_AUTO_AUTH_ENABLED
    # __add_declared_variables "AIRDCPPWEB_AUTO_AUTH_ENABLED"
    # if [ "$AIRDCPPWEB_AUTH_ENABLED" = "true" ]; then
    #     # enable auto login
    #     AIRDCPPWEB_AUTO_AUTH_ENABLED="true"
    # else
    #     AIRDCPPWEB_AUTO_AUTH_ENABLED="false"
    # fi
    # if ! $STELLA_API list_contains "${TANGO_SERVICES_ACTIVE}" "${ORGANIZR2_INSTANCE}"; then
    #     __tango_log "DEBUG" "airdcppweb" "Organizr2 is not declared as an active service in TANGO_SERVICES_ACTIVE. Disable auto login to airdcpp url"
    #     AIRDCPPWEB_AUTO_AUTH_ENABLED="false"
    # fi
    # if [ ! "${ORGANIZR2_AUTHORIZATION}" = "ON" ]; then
    #     __tango_log "DEBUG" "airdcppweb" "Organizr2 auth system is OFF in ORGANIZR2_AUTHORIZATION. Disable auto login to airdcpp url"
    #     AIRDCPPWEB_AUTO_AUTH_ENABLED="false"
    # fi

    # export AIRDCPPWEB_AUTH_BASIC=
    # __add_declared_variables "AIRDCPPWEB_AUTH_BASIC"
    # if [ "$AIRDCPPWEB_AUTO_AUTH_ENABLED" = "true" ]; then
    #     # enable auto login
    #     __tango_log "DEBUG" "airdcppweb" "Enable auto login to airdcppweb url"
    #     AIRDCPPWEB_AUTH_BASIC="$(__base64_basic_authentification "$AIRDCPPWEB_DEFAULT_USER" "$AIRDCPPWEB_DEFAULT_PASSWORD")"
    # else
    #     # disable auto login
    #     if [ "${TANGO_ALTER_GENERATED_FILES}" = "ON" ]; then
    #         __tango_log "DEBUG" "airdcppweb" "Disable auto login to airdcppweb url in generated compose file"
    #         # remove auto login middleware
    #         sed -i -e '/airdcppweb-autoauthbasic\.headers\.customrequestheaders\.Authorization/d' "${GENERATED_DOCKER_COMPOSE_FILE}"
    #          # remove use of auto login middleware
    #         sed -i 's/[^,=]airdcppweb-autoauthbasic[,]\?//g' "${GENERATED_DOCKER_COMPOSE_FILE}"
    #     fi
    # fi
}

# manage auto login middleware for transmission
__airdcppweb_auth() {
    
    if [ ! "$AIRDCPPWEB_AUTO_AUTH_ENABLED" = "true" ]; then
        # disable auto login
        if [ "${TANGO_ALTER_GENERATED_FILES}" = "ON" ]; then
            __tango_log "DEBUG" "transmission" "Disable auto login to airdcppweb url in generated compose file"
            # remove auto login middleware
            sed -i -e '/airdcppweb-autoauthbasic\.headers\.customrequestheaders\.Authorization/d' "${GENERATED_DOCKER_COMPOSE_FILE}"
             # remove use of auto login middleware
            sed -i 's/[^,=]airdcppweb-autoauthbasic[,]\?//g' "${GENERATED_DOCKER_COMPOSE_FILE}"
        fi
    else
        __tango_log "DEBUG" "airdcppweb" "Auto login to airdcppweb url in generated compose file stays active"
    fi

}





__airdcppweb_init() {
    if $STELLA_API list_contains "${TANGO_SERVICES_ACTIVE}" "airdcppweb"; then
        __tango_log "DEBUG" "airdcppweb" "airdcppweb init"
    fi
}

