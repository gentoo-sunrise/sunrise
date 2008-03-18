#!/sbin/runscript
# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

depend() {
	need net
}

start() {
	ebegin "Starting symux"
	start-stop-daemon --start --quiet --exec /usr/sbin/symux
	eend ${?}
}

stop() {
	ebegin "Stopping symux"
	start-stop-daemon --stop --quiet --pidfile /var/run/symux.pid
	eend ${?}
}
