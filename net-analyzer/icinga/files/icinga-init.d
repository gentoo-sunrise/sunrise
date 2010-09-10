#!/sbin/runscript

opts="${opts} reload checkconfig"

depend() {
	need net
	use dns logger firewall
	after mysql postgresql
}

reload()
{
	checkconfig || return 1
	ebegin "Reloading configuration"
	killall -HUP icinga &>/dev/null
	eend $?
}

checkconfig() {
	# Silent Check
	/usr/sbin/icinga -v /etc/icinga/icinga.cfg &>/dev/null && return 0
	# Now we know there's problem - run again and display errors
	/usr/sbin/icinga -v /etc/icinga/icinga.cfg
	eend $? "Configuration Error. Please fix your configfile"
}

start() {
	checkconfig || return 1
	ebegin "Starting icinga"
	touch /var/icinga/icinga.log /var/icinga/status.sav
	chown icinga:icinga /var/icinga/icinga.log /var/icinga/status.sav
	rm -f /var/icinga/rw/icinga.cmd
	start-stop-daemon --quiet --start --startas /usr/sbin/icinga -e HOME="/var/icinga/home" --pidfile /var/icinga/icinga.lock -- -d /etc/icinga/icinga.cfg
	eend $?
}

stop() {
	ebegin "Stopping icinga"
	start-stop-daemon --quiet --stop --pidfile /var/icinga/icinga.lock
	rm -f /var/icinga/status.log /var/icinga/icinga.tmp /var/icinga/icinga.lock /var/icinga/rw/icinga.cmd
	eend $?
}

svc_restart() {
	checkconfig || return 1
	ebegin "Restarting icinga"
	svc_stop
	svc_start
	eend $?
}
