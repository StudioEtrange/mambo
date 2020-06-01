

# PLEX -----------------

__init_service_plex() {
	# get claim token
	__claim_token=
	if [ "$(__is_plex_registered)" = "0" ]; then
		[ "${PLEX_USER}" = "" ] && echo "** Error missing plex user -- set PLEX_USER" && exit 1
		[ "${PLEX_PASSWORD}" = "" ] && echo "** Error missing plex password -- set PLEX_PASSWORD" && exit 1
		__auth_token="$(__get_plex_x_plex_auth_token ${PLEX_USER} ${PLEX_PASSWORD})"
		echo " ** From plex.tv -- get auth token : ${__auth_token}"
		__claim_token="$(__get_plex_claim_token "${__auth_token}")"
		echo " ** From plex.tv -- get claim token : ${__claim_token}"
		if [ "${__claim_token}" = "" ]; then
			echo "** Error while getting claim token"
			exit 1
		fi
	else
		echo "** Plex service is already registred"
	fi
	# if plex was already be claimed, PLEX_CLAIM env var passed to plex is ignored
	export PLEX_CLAIM="${__claim_token}"
	__add_variables "PLEX_CLAIM"

	# stop plex if it was already running
	docker-compose -f "${GENERATED_DOCKER_COMPOSE_FILE}" --project-name ${TANGO_APP_NAME} --project-directory "${TANGO_APP_ROOT}" stop plex
	# init plex
	docker-compose -f "${GENERATED_DOCKER_COMPOSE_FILE}" --project-name ${TANGO_APP_NAME} --project-directory "${TANGO_APP_ROOT}" up -d plex
	# wait for conf and db files created
	sleep 4
	docker-compose -f "${GENERATED_DOCKER_COMPOSE_FILE}" --project-name ${TANGO_APP_NAME} --project-directory "${TANGO_APP_ROOT}" stop plex
	sleep 4
	__set_plex_defaults
}

# test if plex was already claimed
__is_plex_registered() {
	PLEX_PREFERENCES_PATH="${APP_DATA_PATH}/plex/Library/Application Support/Plex Media Server/Preferences.xml"
	[ -f "${PLEX_PREFERENCES_PATH}" ] && __online_token="$(__xml_get_attribute_value "${PLEX_PREFERENCES_PATH}" "/Preferences/@PlexOnlineToken")"

	[ ${#__online_token} -gt 0 ] && echo "1" || echo "0"
}

# get a plex auth token
__get_plex_x_plex_auth_token() {
	local __login="$1"
	local __password="$2"

	__auth_token="$(curl -kLsu "${__login}":"${__password}" -X POST "https://plex.tv/users/sign_in.json" \
	-H "X-Plex-Version: 1.0.0" \
	-H "X-Plex-Product: Mambo" \
	-H "X-Plex-Client-Identifier: Mambo-$(__generate_machine_id)" \
	-H "Content-Type: application/x-www-form-urlencoded; charset=utf-8" | jq -r .user.authentication_token)"

	[ "${__auth_token}" = "null" ] && echo "" || echo "${__auth_token}"
}

# get plex claim token
__get_plex_claim_token() {
	local __x_plex_token="$1"

	__clam_token="$(curl -kLs -X GET "https://plex.tv/api/claim/token.json" \
		-H "X-Plex-Version: 1.0.0" \
		-H "X-Plex-Product: Mambo" \
		-H "X-Plex-Client-Identifier: Mambo-$(__generate_machine_id)" \
		-H "X-Plex-Token: ${__x_plex_token}" \
		-H "Content-Type: application/x-www-form-urlencoded; charset=utf-8" | jq -r .token)"


	[ "${__clam_token}" = "null" ] && echo "" || echo "${__clam_token}"

}


__set_plex_defaults() {
	PLEX_PREFERENCES_PATH="${APP_DATA_PATH}/plex/Library/Application Support/Plex Media Server/Preferences.xml"
	
	
	if [ -f "${PLEX_PREFERENCES_PATH}" ]; then 
		# transcode folder to store temp files
		__xml_set_attribute_value "${PLEX_PREFERENCES_PATH}" "/Preferences" "Preferences" "TranscoderTempDirectory" "/transcode"

		# 'forceAutoAdjustQuality' in Preferences.xml
		# Force clients to use automatic quality for media unless the quality is set higher than the quality of the video.
		# ex: quality set to 4mbps; watching >4mbps will trigger auto quality mode)
		# ex: quality set to original/max; auto quality will never be used & you will always be streaming at the video's original bitrate
		# default : 0
		__xml_set_attribute_value "${PLEX_PREFERENCES_PATH}" "/Preferences" "Preferences" "forceAutoAdjustQuality" "${PLEX_CLIENT_FORCE_AUTO_QUALITY}"

		# 'AllowHighOutputBitrates' in Preferences.xml
		# Force transcode quality to upscale. But can cause high bandwidth usage for clients.
		# default : 0
		__xml_set_attribute_value "${PLEX_PREFERENCES_PATH}" "/Preferences" "Preferences" "AllowHighOutputBitrates" "${PLEX_CLIENT_FORCE_TRANSCODE_UPSCALE}"

		# 'GdmEnabled' in Preferences.xml
		# This enables the media server to discover other servers and players on the local network.
		__xml_set_attribute_value "${PLEX_PREFERENCES_PATH}" "/Preferences" "Preferences" "GdmEnabled" "0"

		# 'TranscoderThrottleBuffer' in Preferences.xml
		# Amount in seconds to buffer before throttling the transcoder.
		# default : 60
		__xml_set_attribute_value "${PLEX_PREFERENCES_PATH}" "/Preferences" "Preferences" "TranscoderThrottleBuffer" "${PLEX_TRANSCODER_THROTTLE_BUFFER}"

		# ManualPortMappingMode="1" in Preferences.xml
		# default : 0
		# 'ManualPortMappingPort' in Preferences.xml
		# Manually specify public port. You may need to enable this to establish a direct connection from outside your network.
		# default : empty
		__xml_set_attribute_value "${PLEX_PREFERENCES_PATH}" "/Preferences" "Preferences" "ManualPortMappingMode" "1"
		__xml_set_attribute_value "${PLEX_PREFERENCES_PATH}" "/Preferences" "Preferences" "ManualPortMappingPort" "${NETWORK_PORT_MAIN}"

		#  TODO custom certificate support
		#		 plex conf extract :
		#		 secureConnections="1" customCertificateDomain="https://iron.studio-etrange.podzone.net:32400" customCertificateKey="mambo" customCertificatePath=" /var/lib/plexmediaserver/certificate.pfx"


		# 'DlnaEnabled' in Preferences.xml
		__xml_set_attribute_value "${PLEX_PREFERENCES_PATH}" "/Preferences" "Preferences" "DlnaEnabled" "0"
		
		# collectUsageData in Preferences.xml
		# sendCrashReports in Preferences.xml
		__xml_set_attribute_value "${PLEX_PREFERENCES_PATH}" "/Preferences" "Preferences" "collectUsageData" "0"
		__xml_set_attribute_value "${PLEX_PREFERENCES_PATH}" "/Preferences" "Preferences" "sendCrashReports" "0"

		# secureConnections in Preferences.xml
		# 0 : Required
		# 1 : Preferred
		# 2 : Disabled
		__xml_set_attribute_value "${PLEX_PREFERENCES_PATH}" "/Preferences" "Preferences" "secureConnections" "${PLEX_HTTPS_MODE}"


		# activate hardware transcoding
		[ ! "${PLEX_HARDWARE_TRANSCODE}" = "" ] && __xml_set_attribute_value "${PLEX_PREFERENCES_PATH}" "/Preferences" "Preferences" "HardwareAcceleratedCodecs" "1" \
												|| __xml_set_attribute_value "${PLEX_PREFERENCES_PATH}" "/Preferences" "Preferences" "HardwareAcceleratedCodecs" "0" \

	fi

	# optimize plex db
	[ ! "${PLEX_DB_CACHE_SIZE}" = "" ] && __set_plex_db_cache_size "${PLEX_DB_CACHE_SIZE}"

}



# optimize plex db
# could ameliorate some result
# https://github.com/Cloudbox/Cloudbox/blob/master/roles/plex/tasks/subtasks/settings/db_cache_size.yml
# https://forums.plex.tv/t/plex-library-performance-tip/176195/10
__set_plex_db_cache_size() {
	if [ ! "$1" = "" ]; then
		PLEX_DATABASE_SUBPATH="Library/Application Support/Plex Media Server/Plug-in Support/Databases/com.plexapp.plugins.library.db"
		# set default_cache_size
		if [ -f "${APP_DATA_PATH}/plex/${PLEX_DATABASE_SUBPATH}" ]; then

			docker-compose -f "${GENERATED_DOCKER_COMPOSE_FILE}" stop plex

			echo "** Actual plex db default_cache_size :"
			docker run --rm -v "${APP_DATA_PATH}/plex:/data" nouchka/sqlite3 "/data/${PLEX_DATABASE_SUBPATH}" "PRAGMA default_cache_size;"
			echo "** Set plex db default_cache_size to $1"
			docker run --rm -v "${APP_DATA_PATH}/plex:/data" nouchka/sqlite3 "/data/${PLEX_DATABASE_SUBPATH}" "PRAGMA default_cache_size=$1;"
			echo "** Actual plex db default_cache_size :"
			docker run --rm -v "${APP_DATA_PATH}/plex:/data" nouchka/sqlite3 "/data/${PLEX_DATABASE_SUBPATH}" "PRAGMA default_cache_size;"
		else
			echo "[${APP_DATA_PATH}/plex/${PLEX_DATABASE_SUBPATH}] do not exist"
			echo "Plex database do not exist yet, launch at least once plex."
		fi
	fi
}

