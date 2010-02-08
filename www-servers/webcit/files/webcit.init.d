#!/sbin/runscript
# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

depend() {
	need net
}

start() {
	ebegin "Starting WebCit"
        start-stop-daemon --start --quiet --background \
		--exec /usr/sbin/webcit -- $WEBCIT_OPTS
	eend $? "Failed to start WebCit"
}

stop() {
	ebegin "Stopping WebCit"
	start-stop-daemon --stop --quiet \
		--exec /usr/sbin/webcit
	eend $? "Failed to stop WebCit"
}

restart() {
	ebegin "Restarting WebCit"
	svc_stop && sleep 3 && svc_start
	eend $? "Failed to restart WebCit"
}

