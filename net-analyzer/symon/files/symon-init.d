#!/sbin/runscript
# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

depend() {
	need net
}

start() {
	ebegin "Starting symon"
	start-stop-daemon --start --quiet --exec /usr/sbin/symon -- -u
	eend ${?}
}

stop() {
	ebegin "Stopping symon"
	start-stop-daemon --stop --quiet --pidfile /var/run/symon.pid
	eend ${?}
}
