# declare variables
__sabnzbd_set_context() {
    export SABNZBD_DATA_PATH="$APP_DATA_PATH/sabnzbd"
    __add_declared_variables "SABNZBD_DATA_PATH"

    # this path depend on the docker image used
    # TODO change path when switching to linuxserver image
    export SABNZBD_INI_PATH="$APP_DATA_PATH/sabnzbd/app/sabnzbd.ini"
    __add_declared_variables "SABNZBD_INI_PATH"

    export SABNZBD_API_KEY="$(__sabnzbd_get_key "API")"
    __add_declared_variables "SABNZBD_API_KEY"
    
    export SABNZBD_NZB_KEY="$(__sabnzbd_get_key "NZB")"
    __add_declared_variables "SABNZBD_NZB_KEY"
}




__sabnzbd_init() {
    __sabnzbd_first_launch
    __sabnzbd_settings
    # we need to reread some values, because sabnzbd may have generate values like api key
    __sabnzbd_set_context

    __tango_log "INFO" "mambo" "we have tweaked some sabnzbd values, you should start/restart it"
}

# sabnzbd auto generate api keys at first launch
__sabnzbd_first_launch() {

    if [ ! -f "${SABNZBD_INI_PATH}" ]; then
        # generate settings file
        __tango_log "DEBUG" "sabnzbd" "Creating settings file"

        __service_down "sabnzbd" "NO_DELETE"
        __service_up "sabnzbd"
        # wait for conf to be created
        sleep 4
        __service_down "sabnzbd" "NO_DELETE"
        sleep 4

    fi
}

# configure sabnzbd
__sabnzbd_settings() {
    if [ "$TANGO_LOG_LEVEL" = "DEBUG" ]; then
        $STELLA_API ansible_play_localhost "$TANGO_APP_ROOT/pool/ansible/ansible-playbook.yml" "$TANGO_APP_ROOT/pool/ansible/roles" "TAGS sabnzbd DEBUG"
    else
        $STELLA_API ansible_play_localhost "$TANGO_APP_ROOT/pool/ansible/ansible-playbook.yml" "$TANGO_APP_ROOT/pool/ansible/roles" "TAGS sabnzbd"
    fi
}


__sabnzbd_get_key() {
    local __key="$1"

    case $__key in
        NZB )
            #cat "${SABNZBD_DATA_PATH}" | sed -e 's,nzb_key[[:space:]]*=[[:space:]]*,nzb_key=,g' | awk 'match($0,/^nzb_key=.*$/) {print substr($0, RSTART+8,RLENGTH);}'
            __ini_get_key_value "${SABNZBD_INI_PATH}" "nzb_key"
        ;;

        API )
            __ini_get_key_value "${SABNZBD_INI_PATH}" "api_key"
        ;;
        
    esac
}