


# FUNCTION USED IN PLUGIN
# NEED transmission volumes
# WAIT for transmission service up

# sample to forward port with PIA in shell and set transmission (torrent) service
#   https://github.com/haugene/docker-transmission-openvpn/blob/master/transmission/updatePort.sh

__transmission_set_port() {
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
        #   if [[ "true" = "$ENABLE_UFW" ]]; then
        #     echo "  + Update UFW rules before changing port in Transmission"

        #     echo "  + denying access to $transmission_peer_port"
        #     ufw deny "$transmission_peer_port"

        #     echo "  + allowing $new_port through the firewall"
        #     ufw allow "$new_port"
        #   fi

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
__transmission_set_context() {
    export TRANSMISSION_AUTH_ENABLED=
    __add_declared_variables "TRANSMISSION_AUTH_ENABLED"

    # if settings file already exist, transmission have been launched at least once
    if [ -f "$TRANSMISSION_DATA_PATH/settings.json" ]; then
        TRANSMISSION_AUTH_ENABLED=$(grep 'rpc-authentication-required\"' "$TRANSMISSION_DATA_PATH/settings.json" \
                     | grep -oE 'true|false')
    else
        #if settings do not exist, transmission have never been launched so we use user and password to check auth enabled
        if [ ! -z "$TRANSMISSION_USER" ] && [ ! -z "$TRANSMISSION_PASSWORD" ]; then
            TRANSMISSION_AUTH_ENABLED="true"
        fi
    fi

    [ "$TRANSMISSION_AUTH_ENABLED" = "true" ] && __tango_log "DEBUG" "transmission" "Transmission auth basic is enabled in settings"
    
    if ! $STELLA_API list_contains "${TANGO_SERVICES_ACTIVE}" "organizr2"; then
        __tango_log "DEBUG" "transmission" "Organizr2 is not declared as an active service in TANGO_SERVICES_ACTIVE. Disable auto login to internal transmission url"
        TRANSMISSION_AUTH_ENABLED="false"
    fi
    if [ ! "${ORGANIZR2_AUTHORIZATION}" = "ON" ]; then
        __tango_log "DEBUG" "transmission" "Organizr2 auth system is OFF in ORGANIZR2_AUTHORIZATION. Disable auto login to internal transmission url"
        TRANSMISSION_AUTH_ENABLED="false"
    fi

    export TRANSMISSION_AUTH_BASIC=
    __add_declared_variables "TRANSMISSION_AUTH_BASIC"
    if [ "$TRANSMISSION_AUTH_ENABLED" = "true" ]; then
        # enable auto login
        __tango_log "DEBUG" "transmission" "Enable auto login to internal transmission url"
        TRANSMISSION_AUTH_BASIC="$(__base64_basic_authentification "$TRANSMISSION_USER" "$TRANSMISSION_PASSWORD")"
    else
        # disable auto login
        if [ "${TANGO_ALTER_GENERATED_FILES}" = "ON" ]; then
            __tango_log "DEBUG" "transmission" "Disable auto login to internal transmission url in generated compose file"
            # remove auto login middleware
            sed -i -e '/transmission-autoauthbasic\.headers\.customrequestheaders\.Authorization/d' "${GENERATED_DOCKER_COMPOSE_FILE}"
             # remove use of auto login middleware
            sed -i 's/[^,=]transmission-autoauthbasic[,]\?//g' "${GENERATED_DOCKER_COMPOSE_FILE}"
        fi
    fi
}

# manage auto login middleware for transmission
__transmission_auth() {
    
    if [ ! "$TRANSMISSION_AUTH_ENABLED" = "true" ]; then
        # disable auto login
        if [ "${TANGO_ALTER_GENERATED_FILES}" = "ON" ]; then
            __tango_log "DEBUG" "transmission" "Disable auto login to internal transmission url in generated compose file"
            # remove auto login middleware
            sed -i -e '/transmission-autoauthbasic\.headers\.customrequestheaders\.Authorization/d' "${GENERATED_DOCKER_COMPOSE_FILE}"
             # remove use of auto login middleware
            sed -i 's/[^,=]transmission-autoauthbasic[,]\?//g' "${GENERATED_DOCKER_COMPOSE_FILE}"
        fi
    else
        __tango_log "DEBUG" "transmission" "Auto login to internal transmission url in generated compose file stays active"
    fi

}