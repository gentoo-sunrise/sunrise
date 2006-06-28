#!/sbin/runscript
# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

depend() {
	before net
}

start() {
	ebegin "Starting nuauth"
	start-stop-daemon --start --quiet --exec /usr/sbin/nuauth -- -D ${NUAUTH_OPTIONS}
	eend $?
}

stop() {
	ebegin "Stopping nuauth"
	start-stop-daemon --stop --quiet --pidfile /var/run/nuauth/nuauth.pid
	eend $?
}
