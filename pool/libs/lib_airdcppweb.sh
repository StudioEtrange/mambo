

# FUNCTION USED INSIDE PLUGIN
# all those functions need to be launched from inside airdcppweb container

# airdcpp API 
#       https://airdcpp.docs.apiary.io/
#       https://github.com/airdcpp-web/airdcpp-webclient/blob/master/airdcpp-webapi/api/CoreSettings.h
#       https://github.com/airdcpp-web/airdcpp-webclient/blob/master/airdcpp-webapi/web-server/WebServerSettings.cpp

__airdcppweb_set_port() {
    
    local _port="$1"
    
    if [ ! "$_port" = "" ]; then


        echo "  + waiting for airdcppweb running"
        until test -f "/.airdcpp/RUNNING"; do sleep 5; done


        echo "  + setting port to $_port"
        #	<InPort type="int">21248</InPort>
        #	<UDPPort type="int">21248</UDPPort>
        #	<TLSPort type="int">21249</TLSPort>

        # TCP/UDP only
        # { "tcp_port", SettingsManager::TCP_PORT, ResourceManager::SETTINGS_TCP_PORT },
		# { "udp_port", SettingsManager::UDP_PORT, ResourceManager::SETTINGS_UDP_PORT },
        curl -v -H "Content-Type: application/json" -X "POST" -d '{ "tcp_port" : '$_port', "udp_port" : '$_port', "tls_mode" : 0, "tls_port" : 1000 }' -u "${AIRDCPPWEB_USER}:${AIRDCPPWEB_PASSWORD}" "http://localhost:5600/api/v1/settings/set"

        

        # TLS port only TODO : not sure if we need to set the 3 ports (or only 1 or 2) : tls_port and udp_port AND tcp_port too
        # { "tls_port", SettingsManager::TLS_PORT, ResourceManager::SETTINGS_TLS_PORT },
        # { "tls_mode", SettingsManager::TLS_MODE, ResourceManager::TRANSFER_ENCRYPTION }
        #curl -v -H "Content-Type: application/json" -X "POST" -d '{ "tls_port" : '$_port', "tls_mode" : 1, "udp_port" : '$_port', "tcp_port" : 1000, }' -u "${AIRDCPPWEB_USER}:${AIRDCPPWEB_PASSWORD}" "http://localhost:5600/api/v1/settings/set"

        
    fi
}


__airdcppweb_restart() {
    __airdcppweb_stop
    sleep 1
    __airdcppweb_start
}

__airdcppweb_stop() {
    echo "* Shutdown airdcppweb"
    curl -s -o /dev/null -I -v -w "%{http_code}" -H "Content-Type: application/json" -X "POST" -u "${AIRDCPPWEB_USER}:${AIRDCPPWEB_PASSWORD}" "http://localhost:5600/api/v1/system/shutdown"
    echo $http_code
}
__airdcppweb_start() {
    echo "* Launch entrypoint to start airdcppweb"
    /entrypoint.sh
}


# -----------------------------------------------------------------------------------------
# declare variables
__airdcppweb_set_context() {
    export AIRDCPPWEB_CFG_PATH="$AIRDCPPWEB_DATA_PATH/DCPlusPlus.xml"
    __add_declared_variables "AIRDCPPWEB_CFG_PATH"

}





__airdcppweb_init() {
    if $STELLA_API list_contains "${TANGO_SERVICES_ACTIVE}" "airdcppweb"; then
        __tango_log "DEBUG" "airdcppweb" "airdcppweb init"
        __airdcppweb_init_files
        # configure
        __airdcppweb_settings
    fi
}



__airdcppweb_init_files() {
    if [ ! -f "${AIRDCPPWEB_DATA_PATH}" ]; then
        # generate settings file
        __tango_log "DEBUG" "medusa" "Creating settings file"

        __service_down "airdcppweb" "NO_DELETE"
        __service_up "airdcppweb" "NO_EXEC_PLUGINS"
        # wait for conf to be created
        sleep 10
        __service_down "airdcppweb" "NO_DELETE"
        sleep 10
    fi
}


# configure airdcppweb
__airdcppweb_settings() {
    __airdcppweb_set_user
}


# set the configured user
# to set an administrative user, we need to use airdcppd --add-user
# we cannot add user by directly modifiying json file, because it use some non reproductible hash to store password
__airdcppweb_set_user() {
    __service_up "airdcppweb" "NO_EXEC_PLUGINS"
    sleep 1
    # to set a user we need to remove it before
    __compose_exec "airdcppweb" 'set -- sh -c "( sleep .1 ; echo ${AIRDCPPWEB_USER} ) | /airdcpp-webclient/airdcppd --remove-user"'

    __compose_exec "airdcppweb" 'set -- sh -c "( sleep .1 ; echo ${AIRDCPPWEB_USER} ; sleep .1 ; echo ${AIRDCPPWEB_PASSWORD} ; sleep .1 ; echo ${AIRDCPPWEB_PASSWORD}) | /airdcpp-webclient/airdcppd --add-user"'
    sleep 1
    __service_down "airdcppweb" "NO_DELETE"
}
