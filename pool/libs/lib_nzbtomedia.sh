# declare variables
__nzbtomedia_set_context() {
    echo
}




__nzbtomedia_init() {
    __nzbtomedia_first_launch
    __nzbtomedia_settings
    # we need to reread some values, because sabnzbd may have generate values like api key
    __nzbtomedia_set_context
}

# install nzbtomedia
__nzbtomedia_first_launch() {
    __service_up "nzbtomedia"
    __service_down "nzbtomedia"
}

# configure sabnzbd
__nzbtomedia_settings() {
    if [ "$TANGO_LOG_LEVEL" = "DEBUG" ]; then
        $STELLA_API ansible_play_localhost "$TANGO_APP_ROOT/pool/ansible/ansible-playbook.yml" "$TANGO_APP_ROOT/pool/ansible/roles" "TAGS nzbtomedia DEBUG"
    else
        $STELLA_API ansible_play_localhost "$TANGO_APP_ROOT/pool/ansible/ansible-playbook.yml" "$TANGO_APP_ROOT/pool/ansible/roles" "TAGS nzbtomedia"
    fi
}

