#!/sbin/runscript

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/usr/bin/iaxmodem
NAME=iaxmodem
DESC=iaxmodem

depend() {
        need net hylafax
}

start() {
	ebegin "Starting $DESC: "
	start-stop-daemon --start --quiet --pidfile /var/run/$NAME.pid \
		--exec $DAEMON
	eend $?
}
stop() {
	ebegin "Stopping $DESC: "
	start-stop-daemon --stop --quiet --pidfile /var/run/$NAME.pid \
		--exec $DAEMON
	eend $?
}
reload() {
	ebegin "Reloading $DESC: "
	if [ -e /var/run/$NAME.pid ]; then
	    kill -HUP $(cat /var/run/$NAME.pid)
	    eend 0
	else
	    echo "$NAME not running!"
	    eend 1
	fi
}
