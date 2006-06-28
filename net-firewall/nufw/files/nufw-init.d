#!/sbin/runscript
# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

depend() {
	before net
}

start() {
	ebegin "Starting nufw"
	start-stop-daemon --start --quiet --exec /usr/sbin/nufw -- -D ${NUFW_OPTIONS}
	eend $?
}

stop() {
	ebegin "Stopping nufw"
	start-stop-daemon --stop --quiet --pidfile /var/run/nufw.pid
	eend $?
}
