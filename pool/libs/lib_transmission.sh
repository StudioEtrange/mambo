


# FUNCTION USED INSIDE PLUGIN
# NEED transmission volumes
# WAIT for transmission service up
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
    export TRANSMISSION_CFG_PATH="$TRANSMISSION_DATA_PATH/settings.json"
    __add_declared_variables "TRANSMISSION_CFG_PATH"

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

    [ "$TRANSMISSION_AUTH_ENABLED" = "true" ] && __tango_log "DEBUG" "transmission" "Transmission auth is enabled in settings"
    
    export TRANSMISSION_AUTO_AUTH_ENABLED
    __add_declared_variables "TRANSMISSION_AUTO_AUTH_ENABLED"
    if [ "$TRANSMISSION_AUTH_ENABLED" = "true" ]; then
        # enable auto login
        TRANSMISSION_AUTO_AUTH_ENABLED="true"
    else
        TRANSMISSION_AUTO_AUTH_ENABLED="false"
    fi
    if ! $STELLA_API list_contains "${TANGO_SERVICES_ACTIVE}" "${ORGANIZR2_INSTANCE}"; then
        __tango_log "DEBUG" "transmission" "Organizr2 is not declared as an active service in TANGO_SERVICES_ACTIVE. Disable auto login to internal transmission url"
        TRANSMISSION_AUTO_AUTH_ENABLED="false"
    fi
    if [ ! "${ORGANIZR2_AUTHORIZATION}" = "ON" ]; then
        __tango_log "DEBUG" "transmission" "Organizr2 auth system is OFF in ORGANIZR2_AUTHORIZATION. Disable auto login to internal transmission url"
        TRANSMISSION_AUTO_AUTH_ENABLED="false"
    fi


    export TRANSMISSION_AUTH_BASIC=
    __add_declared_variables "TRANSMISSION_AUTH_BASIC"
    if [ "$TRANSMISSION_AUTO_AUTH_ENABLED" = "true" ]; then
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
    
    if [ ! "$TRANSMISSION_AUTO_AUTH_ENABLED" = "true" ]; then
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





__transmission_init() {
    if $STELLA_API list_contains "${TANGO_SERVICES_ACTIVE}" "transmission"; then
        __tango_log "DEBUG" "transmission" "transmission init"
        __transmission_init_files
        # configure
        __transmission_settings
    fi
}

__transmission_init_files() {
    if [ ! -f "${TRANSMISSION_CFG_PATH}" ]; then
        # generate settings file
        __tango_log "DEBUG" "transmission" "Creating settings file"

        __service_down "transmission" "NO_DELETE"
        __service_up "transmission"
        # wait for conf to be created
        sleep 4
        __service_down "transmission" "NO_DELETE"
        sleep 4
    fi
}

# configure sabnzbd
__transmission_settings() {
    if [ "$TANGO_LOG_LEVEL" = "DEBUG" ]; then
        $STELLA_API ansible_play_localhost "$TANGO_APP_ROOT/pool/ansible/ansible-playbook.yml" "$TANGO_APP_ROOT/pool/ansible/roles" "TAGS transmission DEBUG"
    else
        $STELLA_API ansible_play_localhost "$TANGO_APP_ROOT/pool/ansible/ansible-playbook.yml" "$TANGO_APP_ROOT/pool/ansible/roles" "TAGS transmission"
    fi
    __tango_log "INFO" "mambo" "we have tweaked some transmission values, you should start/restart it"
}
