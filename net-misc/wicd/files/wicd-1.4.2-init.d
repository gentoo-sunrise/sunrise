#!/sbin/runscript
# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

opts="start stop restart"

WICD_DAEMON="/opt/wicd/daemon.py"

depend() {
	need dbus
}

start() {
	ebegin "Starting wicd daemon"
	start-stop-daemon --start --exec $WICD_DAEMON &>/dev/null
	eend $?
}

stop() {
	ebegin "Stopping wicd daemon"
	start-stop-daemon --stop --exec $WICD_DAEMON &>/dev/null
	eend $?
}
