
# declare variables
__medusa_set_context() {
    export MEDUSA_DATA_PATH="$APP_DATA_PATH/medusa"
    __add_declared_variables "MEDUSA_DATA_PATH"

    export MEDUSA_INI_PATH="$APP_DATA_PATH/medusa/config.ini"
    __add_declared_variables "MEDUSA_INI_PATH"

    export MEDUSA_API_KEY="$(__medusa_get_key "API")"
    __add_declared_variables "MEDUSA_API_KEY"
}

__medusa_init() {
    if $STELLA_API list_contains "${TANGO_SERVICES_ACTIVE}" "medusa"; then
        __medusa_init_files
        # configure
        __medusa_settings
        # we need to reread some values, because sabnzbd may have generate values like api key
        __medusa_set_context
    fi
}


__medusa_init_files() {
    if [ ! -f "${MEDUSA_INI_PATH}" ]; then
        # generate settings file
        __tango_log "DEBUG" "medusa" "Creating settings file"

        __service_down "medusa" "NO_DELETE"
        __service_up "medusa"
        # wait for conf to be created
        sleep 15
        __service_down "medusa" "NO_DELETE"
        sleep 10
    fi
}

# configure sabnzbd
__medusa_settings() {

    # if not exist generate an api key
    # eval is used to ignore "" value
    [ "$(eval echo $MEDUSA_API_KEY)" = "" ] && export MEDUSA_API_KEY="$($STELLA_API generate_password 32 "[:alnum:]")"
    if [ "$TANGO_LOG_LEVEL" = "DEBUG" ]; then
        $STELLA_API ansible_play_localhost "$TANGO_APP_ROOT/pool/ansible/ansible-playbook.yml" "$TANGO_APP_ROOT/pool/ansible/roles" "TAGS medusa DEBUG"
    else
        $STELLA_API ansible_play_localhost "$TANGO_APP_ROOT/pool/ansible/ansible-playbook.yml" "$TANGO_APP_ROOT/pool/ansible/roles" "TAGS medusa"
    fi
    __tango_log "INFO" "mambo" "we have tweaked some medusa values, you should start/restart it"
}


__medusa_get_key() {
    local __key="$1"

    case $__key in

        API )
            # eval is used to ignore "" value
            eval echo "$(__ini_get_key_value "${MEDUSA_INI_PATH}" "api_key")"
        ;;
        
    esac
}