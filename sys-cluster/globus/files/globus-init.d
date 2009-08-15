#!/sbin/runscript
# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

GLOBUS_LOCATION=/opt/globus4

source "${GLOBUS_LOCATION}"/etc/globus-user-env.sh

depend() {
	after localmount netmount nfsmount dns
	need net
}

PIDFILE="/var/run/globus.pid"

checkconfig() {
# FIXME: find an appropriate file -- like the certificates or something
#	if [ ! -e /etc/SOME_FILE... ] ; then
#		eerror "You need an SOME_FILE file to run globus"
#		return 1
#	fi

	# verify presence of server binary
	if ! [ -x "${GLOBUS_LOCATION}/bin/globus-start-container" ]; then
		eerror "Could not find executable ${GLOBUS_LOCATION}/bin/globus-start-container"
		return 1
	fi
}


start() {
	checkconfig || return 1

	ebegin "Starting Globus WS Container"
	start-stop-daemon --start --quiet --pidfile "${PIDFILE}" \
		--exec "${GLOBUS_LOCATION}"/bin/globus-start-container -- \
			${CONTAINER_OPTS}

#		--stdout "${LOG_FILE}" \

	eend $?
}

stop() {
	ebegin "Stopping Globus WS Container"

	local container ret
	container="$(mktemp -d)"

	start-stop-daemon --stop --quiet --pidfile "${PIDFILE}" \
		--stdout "${LOG_FILE}" \
		--exec "${GLOBUS_LOCATION}"/bin/grid-proxy-init -- \
						-cert /etc/grid-security/containercert.pem \
						-key  /etc/grid-security/containerkey.pem \
						-out  "${container}"/containerproxy.pem 

	X509_USER_PROXY=${container}/containerproxy.pem \
		"${GLOBUS_LOCATION}"/bin/globus-stop-container

	ret = $? # cache globus-stop-container's return code.

	rm -rf "${container}"
    
	eend ${ret}
}
