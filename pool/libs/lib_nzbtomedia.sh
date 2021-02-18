# declare variables
# __nzbtomedia_set_context() {

# }



__nzbtomedia_init() {
    if $STELLA_API list_contains "${TANGO_SERVICES_ACTIVE}" "nzbtomedia"; then
        __nzbtomedia_init_files
        # configure
        __nzbtomedia_settings
    fi
}

# install nzbtomedia
__nzbtomedia_init_files() {
    __service_up "nzbtomedia"
    __service_down "nzbtomedia"
}

# configure nzbtomedia
__nzbtomedia_settings() {
    if [ "$TANGO_LOG_LEVEL" = "DEBUG" ]; then
        $STELLA_API ansible_play_localhost "$TANGO_APP_ROOT/pool/ansible/ansible-playbook.yml" "$TANGO_APP_ROOT/pool/ansible/roles" "TAGS nzbtomedia DEBUG"
    else
        $STELLA_API ansible_play_localhost "$TANGO_APP_ROOT/pool/ansible/ansible-playbook.yml" "$TANGO_APP_ROOT/pool/ansible/roles" "TAGS nzbtomedia"
    fi
}

