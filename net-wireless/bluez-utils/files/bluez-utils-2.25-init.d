#!/sbin/runscript
# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/bluez-utils/files/bluez-utils-2.25-init.d,v 1.1 2006/02/07 14:04:40 liquidx Exp $

UART_CONF="/etc/bluetooth/uart"

depend() {
	after coldplug
	after dbus
}

start_uarts() {
	[ -f /usr/sbin/hciattach -a -f ${UART_CONF} ] || return
	grep -v '^#' ${UART_CONF} | while read i; do
		/usr/sbin/hciattach $i
	done
}

stop_uarts() {
	killall hciattach > /dev/null 2>&1
}

start() {
   	ebegin "Starting Bluetooth"

	if [ "${HID2HCI_ENABLE}" = "true" -a -x /usr/sbin/hid2hci ]; then
		ebegin "    Running hid2hci"
		/usr/sbin/hid2hci -0 -q    #be quiet
		/bin/sleep 1 # delay for hid's to be detected by hotplug
		eend $?
	fi

	if [ "${HCID_ENABLE}" = "true" -a -x /usr/sbin/hcid ]; then
		if [ -f "${HCID_CONFIG}" ]; then
			ebegin "    Starting hcid"
			start-stop-daemon --start --quiet \
				--exec /usr/sbin/hcid -- -f $HCID_CONFIG
			eend $?
	    else
			ewarn "Not enabling hcid because HCID_CONFIG is missing."
	    fi
	fi

	if [ "${SDPD_ENABLE}" = "true" -a -x /usr/sbin/sdpd ]; then
		ebegin "    Starting sdpd"
		start-stop-daemon --start --quiet --exec /usr/sbin/sdpd
		eend $?
	fi

	if [ "${HIDD_ENABLE}" = "true" -a -x /usr/bin/hidd ]; then
		ebegin "    Starting hidd"
		start-stop-daemon --start --quiet \
			--exec /usr/bin/hidd -- ${HIDD_OPTIONS} --server
		eend $?
	fi

	if [ "${RFCOMM_ENABLE}" = "true" -a -x /usr/bin/rfcomm ]; then
		if [ -f "${RFCOMM_CONFIG}" ]; then
			ebegin "    Starting rfcomm"
			/usr/bin/rfcomm -f ${RFCOMM_CONFIG} bind all
			eend $?
		else
			ewarn "Not enabling rfcomm because RFCOMM_CONFIG does not exists"
		fi
	fi

	if [ "${DUND_ENABLE}" = "true" -a -x /usr/bin/dund ]; then
		if [ -n "${DUND_OPTIONS}" ]; then
			ebegin "    Starting dund"
			start-stop-daemon --start --quiet \
				--exec /usr/bin/dund -- ${DUND_OPTIONS}
			eend $?
		else
			ewarn "Not starting dund because DUND_OPTIONS not defined."
		fi
	fi

	if [ "${PAND_ENABLE}" = "true" -a -x /usr/bin/pand ]; then
		if [ -n "${PAND_OPTIONS}" ]; then
			ebegin "    Starting pand"
			start-stop-daemon --start --quiet \
				--exec /usr/bin/pand -- ${PAND_OPTIONS}
			eend $?
		else
			ewarn "Not starting pand because PAND_OPTIONS not defined."
		fi
	fi

	start_uarts
	eend 0
}

stop() {
	ebegin "Shutting down Bluetooth"

	if [ "${PAND_ENABLE}" = "true" -a -x /usr/bin/pand ]; then
		ebegin "    Stopping pand"
		start-stop-daemon --stop --quiet --exec /usr/bin/pand
		eend $?
	fi

	if [ "${DUND_ENABLE}" = "true" -a -x /usr/bin/dund ]; then
		ebegin "    Stopping dund"
		start-stop-daemon --stop --quiet --exec /usr/bin/dund
		eend $?
	fi

	if [ "${RFCOMM_ENABLE}" = "true" -a -x /usr/bin/rfcomm ]; then
		ebegin "    Stopping rfcomm"
		/usr/bin/rfcomm release all
		eend $?
	fi

	if [ "${HIDD_ENABLE}" = "true" -a -x /usr/bin/hidd ]; then
		ebegin "    Stopping hidd"
		start-stop-daemon --stop --quiet --exec /usr/bin/hidd
		eend $?
	fi


	if [ "${SDPD_ENABLE}" = "true" -a -x /usr/sbin/sdpd ]; then
		ebegin "    Stopping sdpd"
		start-stop-daemon --stop --quiet --exec /usr/sbin/sdpd
		eend $?
	fi

	if [ "${HCID_ENABLE}" = "true" -a -x /usr/sbin/hcid ]; then
		ebegin "    Stopping hcid"
		start-stop-daemon --stop --quiet --exec /usr/sbin/hcid
		eend $?
	fi

	stop_uarts
	eend 0
}

restart() {
	svc_stop
	svc_start
}
