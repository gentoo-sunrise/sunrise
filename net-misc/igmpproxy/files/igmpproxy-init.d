#!/sbin/runscript
# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

depend() {
	need net
	use logger
}

start() {
	ebegin "Starting IGMPproxy"
	start-stop-daemon --start --exec /usr/sbin/igmpproxy -- -c /etc/igmpproxy.conf
	eend $?
}

stop() {
	ebegin "Stopping IGMPproxy"
	start-stop-daemon --stop --exec /usr/sbin/igmpproxy
	eend $?
}

