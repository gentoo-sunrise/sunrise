#!/sbin/runscript

depend() {
	need net
}

start() {
	ebegin "Starting batman"
	start-stop-daemon --start --quiet --background --exec /usr/sbin/batman -- ${BATMAN_OPTIONS} ${BATMAN_INTERFACES}
	eend $?
}

stop() {
	ebegin "Stopping batman"
	start-stop-daemon --stop --quiet --exec /usr/sbin/batman
	eend $?
}
