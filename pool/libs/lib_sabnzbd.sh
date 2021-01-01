# declare variables
__sabnzbd_set_context() {
    export SABNZBD_DATA_PATH="$APP_DATA_PATH/sabnzbd"
    __add_declared_variables "SABNZBD_DATA_PATH"

    export SABNZBD_API_KEY="$(__sabnzbd_get_key "API")"
    __add_declared_variables "SABNZBD_API_KEY"
    
    export SABNZBD_NZB_KEY="$(__sabnzbd_get_key "NZB")"
    __add_declared_variables "SABNZBD_NZB_KEY"
}




__sabnzbd_init() {
    [ "${SABNZBD_USER}" = "" ] && __tango_log "ERROR" "sabnzbd" "Error missing sabnzbd user -- set SABNZBD_USER" && exit 1
	[ "${SABNZBD_PASSWORD}" = "" ] && __tango_log "ERROR" "sabnzbd" "Error missing sabnzbd password -- set SABNZBD_PASSWORD" && exit 1
    __sabnzbd_first_launch
    __sabnzbd_settings
    # we need to reread some values, because sabnzbd may have generate values like api key
    __sabnzbd_set_context
}

# sabnzbd auto generate api keys at first launch
__sabnzbd_first_launch() {

    if [ ! -f "$SABNZBD_DATA_PATH/sabnzbd.ini" ]; then
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
            #cat "$SABNZBD_DATA_PATH/sabnzbd.ini" | sed -e 's,nzb_key[[:space:]]*=[[:space:]]*,nzb_key=,g' | awk 'match($0,/^nzb_key=.*$/) {print substr($0, RSTART+8,RLENGTH);}'
            __ini_get_key_value "$SABNZBD_DATA_PATH/sabnzbd.ini" "nzb_key"
        ;;

        API )
            __ini_get_key_value "$SABNZBD_DATA_PATH/sabnzbd.ini" "api_key"
        ;;
        
    esac
}