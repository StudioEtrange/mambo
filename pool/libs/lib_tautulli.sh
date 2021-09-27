# declare variables
__tautulli_set_context() {

    export TAUTULLI_API_KEY="$(__tautulli_get_key)"
    __add_declared_variables "TAUTULLI_API_KEY"
    
}



__tautulli_get_key() {

    [ -f "${TAUTULLI_DATA_PATH}/config.ini" ] && __ini_get_key_value "${TAUTULLI_DATA_PATH}/config.ini" "api_key"

}