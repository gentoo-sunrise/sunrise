#!/sbin/runscript
# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

start() {
	ebegin "Starting IGMPproxy"
	start-stop-daemon --start --exec /usr/bin/igmpproxy -- -c "${IGMPPROXY_CONFIG}"
	eend $?
}

stop() {
	ebegin "Stopping IGMPproxy"
	start-stop-daemon --stop --exec /usr/bin/igmpproxy
	eend $?
}

