#!/sbin/runscript
# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

source ${GLOBUS_LOCATION}/etc/globus-user-env.sh

depend() {
    need net
}

start() {
    ebegin "Starting Globus WS Container"
    ${GLOBUS_LOCATION}/bin/globus-start-container ${CONTAINER_OPTS} >
${LOG_FILE} 2>&1 &
    eend ${?}
}

stop() {
    ebegin "Stopping Globus WS Container"
        ${GLOBUS_LOCATION}/bin/grid-proxy-init \
                        -cert /etc/grid-security/containercert.pem \
                        -key /etc/grid-security/containerkey.pem \
                        -out /tmp/containerproxy.pem  > /dev/null
        export X509_USER_PROXY=/tmp/containerproxy.pem
        ${GLOBUS_LOCATION}/bin/globus-stop-container
        export  X509_USER_PROXY
        rm /tmp/containerproxy.pem
    eend ${?}
}
