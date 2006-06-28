#!/sbin/runscript

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
