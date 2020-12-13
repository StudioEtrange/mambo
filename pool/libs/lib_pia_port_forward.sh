
# NEED to be connected with PIA vpn
# WAIT for vpn service up
# NEED PIA_FOLDER defined

# about forwarding port with PIA
#   only some PIA VPN server allow port forwarding, list here : https://www.privateinternetaccess.com/helpdesk/kb/articles/can-i-use-port-forwarding-without-using-the-pia-client
#   https://www.privateinternetaccess.com/helpdesk/kb/articles/can-i-use-port-forwarding-without-using-the-pia-client
#   https://www.privateinternetaccess.com/installer/port_forwarding.sh
# sample to forward port with PIA in shell and set transmission (torrent) service
#   https://github.com/haugene/docker-transmission-openvpn/blob/master/transmission/updatePort.sh


pia_new_client_id() {
    local pia_client_id_file="$1"
    head -n 100 /dev/urandom | sha256sum | tr -d " -" | tee ${pia_client_id_file}
}

# NOTE : ask to open a port to private internet access vpn (PIA) provider and set a global var with it
export PIA_FORWARD_PORT=
pia_get_port() {
    local pia_data_folder="$1"
    mkdir -p "${pia_data_folder}"
    pia_client_id_file="${pia_data_folder}/pia_client_id"
    pia_port_file="${pia_data_folder}/pia_open_port"

    local new_port=


    # doc says : "Within two minutes of connecting the VPN"
    # vpn docker container should have healthy status
    wait_time=30
    echo "  + Wait for tunnel to be fully initialized and PIA is ready to give us a port ($wait_time sec.)"
    sleep $wait_time

    # NOTE we should always generate a new id to try to force obtain a new port 
    #       to really obtain a new port we must down the vpn connection first AND generate a new id 
    #pia_client_id="$(cat ${pia_client_id_file} 2>/dev/null)"
    pia_client_id=

    if [[ -z "${pia_client_id}" ]]; then
        echo -n "  + Generating new client id for PIA : "
        pia_client_id=$(pia_new_client_id ${pia_client_id_file})
        echo "${pia_client_id}"
    else
        echo "  + Using existing client id for PIA : ${pia_client_id}"
    fi

    # Get the port
    port_assignment_url="http://209.222.18.222:2000/?client_id=$pia_client_id"

    echo "  + Requesting a port"
    # if type curl 1>/dev/null 2>&1; then
    #     pia_response=$(curl -s -f "$port_assignment_url")
    # else
    #     pia_response=$(wget -q -O - "$port_assignment_url")
    # fi
    pia_response=$(__tango_curl -s -f "$port_assignment_url")

    pia_curl_exit_code=$?
    echo "  + Raw response : ${pia_response}"

    old_port="$(cat ${pia_port_file} 2>/dev/null)"

    if [[ -z "$pia_response" ]]; then
        echo "  + Port forwarding is already activated on this connection, has expired, or you are not connected to a PIA region that supports port forwarding"
    fi

    # Check for curl error (curl will fail on HTTP errors with -f flag)
    if [[ ${pia_curl_exit_code} -ne 0 ]]; then
        echo "  + curl/wget encountered an error looking up new port: $pia_curl_exit_code"
        if [[ -z "$old_port" ]]; then
            echo "  + no previously reserved port found"
            PIA_FORWARD_PORT=
            return $pia_curl_exit_code
        else
            echo "  + using previous port $old_port"
            PIA_FORWARD_PORT=$old_port
            return 0
        fi
    fi

    # Check for errors in PIA response
    error=$(echo "  + $pia_response" | grep -oE "\"error\".*\"")
    if [[ ! -z "$error" ]]; then
        echo "  + PIA returned an error: $error"
        PIA_FORWARD_PORT=
        return 1
    fi

    # Get new port, check if empty
    new_port=$(echo "  + $pia_response" | grep -oE "[0-9]+")
    if [[ -z "$new_port" ]]; then
        echo "  + Could not find new port from PIA"
        if [[ -z "$old_port" ]]; then
            echo "  + No old previously reserved port found"
            PIA_FORWARD_PORT=
            return 1
        else
            echo "  + using previous port $old_port"
            return 0
        fi
    fi
    echo "  + Got new port $new_port from PIA"
    PIA_FORWARD_PORT=$new_port
    echo $new_port > $pia_port_file
    return 0
}
