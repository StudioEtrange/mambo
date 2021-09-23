
# NEED to be connected with PIA vpn
# NEED awk
# NEED curl
# NEED ip
# NEED jq
# WAIT for vpn service up

# script that get a forwarding port with PIA VPN provider
#   all PIA VPN server allow port forwarding except from USA
#   PIA reference scripts : https://github.com/pia-foss/manual-connections
#        sample for transmission + PIA vpn : https://github.com/haugene/docker-transmission-openvpn/blob/master/openvpn/pia/update-port.sh


pia_install_script() {
    export PIA_FOLDER="${1}"

    if [ -f "${PIA_FOLDER}/manual-connections/LICENSE" ]; then
        echo "  + ${PLUGIN} already installed in ${PIA_FOLDER}/manual-connections"
    else
        mkdir -p "${PIA_FOLDER}/manual-connections"
        #cp -Rf "/pool/mambo/artefacts/manual-connections" "${PIA_FOLDER}/"
        curl -fksL "https://github.com/StudioEtrange/manual-connections/archive/master.tar.gz" -o "/tmp/manual-connections.tar.gz"
        cd "${PIA_FOLDER}/manual-connections"
        tar xvzf "/tmp/manual-connections.tar.gz" --strip-components=1
    fi
}



pia_setup_script() {
    local __plugin_name="$1"
    # change default path used by pia provided scripts
    find "${PIA_FOLDER}/manual-connections" -type f -exec sed -i s,/opt/piavpn-manual,/plugins_data/${__plugin_name},g {} \;
    # do not verify certificate because there seems to have a problem with crt file provided by pia scritps
    # https://github.com/pia-foss/manual-connections/issues/85
    sed -i "s,curl -,curl -k -,g" ${PIA_FOLDER}/manual-connections/port_forwarding.sh
}

export PIA_FORWARD_PORT=
pia_get_port() {
    # get PF_GATEWAY
    echo "  - get PF_GATEWAY"
    export PF_GATEWAY="$(ip route | head -1 | grep tun | awk '{ print $3 }')"
    echo "  - get PF_GATEWAY : $PF_GATEWAY"


    # get PIA_TOKEN
    echo "  - get PIA_TOKEN"
    rm -f "${PIA_FOLDER}/token"
    auth_var="VPN_${VPN_ID}_VPN_AUTH"
    auth_string="${!auth_var}"
    auth_string=(${auth_string//;/ })
    export PIA_USER"=${auth_string[0]}"
    export PIA_PASS="${auth_string[1]}"
    ${PIA_FOLDER}/manual-connections/get_token.sh
    export PIA_TOKEN="$( awk 'NR == 1' ${PIA_FOLDER}/token )"
    echo "  - get PIA_TOKEN : $PIA_TOKEN"

    
    # get PF_HOSTNAME
    echo "  - get PF_HOSTNAME"
    files_var="VPN_${VPN_ID}_VPN_FILES"
    files_var="${!files_var}"
    files_var="${files_var/%;*}"
    files_var="${files_var[0]}"
    file_ovpn="/vpn/${files_var}"
    export PF_HOSTNAME="$(awk -F ' ' '/^remote\ / {print $2}' $file_ovpn)"
    echo "  - get PF_HOSTNAME : $PF_HOSTNAME"




    # ask PIA vpn provider to forward a port
    # launch background task to keep port open
    nohup -- ${PIA_FOLDER}/manual-connections/port_forwarding.sh 1>${PIA_FOLDER}/log.log 2>&1 &
    
    sleep 7
    [ -f "${PIA_FOLDER}/port_forwarding" ] && export PIA_FORWARD_PORT="$( awk 'NR == 1' ${PIA_FOLDER}/port_forwarding )"
}
