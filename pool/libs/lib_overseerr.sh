
# declare variables
__overseerr_set_context() {
    export OVERSEERR_API_KEY="$(__overseerr_get_key "API")"
    __add_declared_variables "OVERSEERR_API_KEY"
}



__overseerr_get_key() {
    local __key="$1"

    case $__key in

        API )
            [ -f "${OVERSEERR_DATA_PATH}/settings.json" ] && cat "${OVERSEERR_DATA_PATH}/settings.json" | jq -r 'with_entries(select(.main.apiKey != null))'
        ;;
        
    esac
}