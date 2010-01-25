# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit linux-info perl-app

DESCRIPTION="A small daemon which collects system performance statistics - with a near-infinite number of plugins"
HOMEPAGE="http://collectd.org"
SRC_URI="${HOMEPAGE}/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="contrib debug kernel_linux kernel_FreeBSD kernel_Darwin"

# hal is autodetected by configure, so there is no point in a hal useflag.
# DEPENDing it for now for the UUID plugin, so we get a consistent state...
# TODO: patch configure.in to provide with/without-hal

# The plugin lists have to follow here since they extend IUSE

COLLECTD_SOURCE_PLUGINS="apache apcups apple_sensors ascent battery bind conntrack contextswitch
	cpu cpufreq curl dbi df disk dns email entropy exec filecount fscache gmond
	hddtemp interface ipmi iptables ipvs irq java libvirt load madwifi mbmon memcachec
	memcached memory multimeter mysql netlink network nfs nginx ntpd nut olsrd
	onewire openvpn oracle perl postgresql powerdns processes protocols python routeros
	rrdcached sensors serial snmp swap table tail tape tcpconns teamspeak2 ted thermal
	tokyotyrant uptime users vmem vserver wireless zfs_arc"

COLLECTD_TARGET_PLUGINS="csv exec logfile network notify_desktop notify_email perl python
	rrdcached rrdtool syslog unixsock write_http"

COLLECTD_FILTER_PLUGINS="match_empty_counter match_hashed match_regex match_timediff match_value
	target_notification target_replace target_scale target_set"

COLLECTD_MISC_PLUGINS="uuid"

COLLECTD_PLUGINS="${COLLECTD_SOURCE_PLUGINS} ${COLLECTD_TARGET_PLUGINS}
	${COLLECTD_FILTER_PLUGINS} ${COLLECTD_MISC_PLUGINS}"

COLLECTD_DISABLED_PLUGINS="curl_json netapp ping xmms"

for plugin in ${COLLECTD_PLUGINS}; do
	IUSE="${IUSE} cd_${plugin}"
done

# Now come the dependencies.

COMMON_DEPEND="
	cd_apache?		( net-misc/curl )
	cd_ascent?		( net-misc/curl dev-libs/libxml2 )
	cd_bind?		( dev-libs/libxml2 )
	cd_curl?		( net-misc/curl )
	cd_dbi?			( dev-db/libdbi )
	cd_dns?			( net-libs/libpcap )
	cd_gmond?		( sys-cluster/ganglia )
	cd_ipmi?		( >=sys-libs/openipmi-2.0.11 )
	cd_iptables?		( net-firewall/iptables )
	cd_java?		( virtual/jre )
	cd_libvirt?		( app-emulation/libvirt dev-libs/libxml2 )
	cd_memcachec?		( dev-libs/libmemcached )
	cd_mysql?		( >=virtual/mysql-5.0 )
	cd_netlink?		( sys-apps/iproute2 )
	cd_network?		( dev-libs/libgcrypt )
	cd_nginx?		( net-misc/curl )
	cd_notify_desktop?	( x11-libs/libnotify )
	cd_notify_email?	( >=net-libs/libesmtp-1.0.4 dev-libs/openssl )
	cd_nut?			( >=sys-power/nut-2.2.0 )
	cd_onewire?		( sys-fs/owfs )
	cd_oracle?		( >=dev-db/oracle-instantclient-basic-11.1.0.7.0 )
	cd_perl?		( dev-lang/perl[ithreads] sys-devel/libperl[ithreads] )
	cd_postgres?		( >=virtual/postgresql-base-8.2 )
	cd_python?		( || ( dev-lang/python:2.4  dev-lang/python:2.5 dev-lang/python:2.6 ) )
	cd_rrdcached?		( >=net-analyzer/rrdtool-1.4 )
	cd_rrdtool?		( >=net-analyzer/rrdtool-1.2.27 )
	cd_sensors?		( sys-apps/lm_sensors )
	cd_snmp?		( net-analyzer/net-snmp )
	cd_tokyotyrant?		( net-misc/tokyotyrant )
	cd_uuid? 		( sys-apps/hal )
	cd_write_http?		( net-misc/curl )

	kernel_FreeBSD?	(
		cd_disk?	( >=sys-libs/libstatgrab-0.16 )
		cd_interface?	( >=sys-libs/libstatgrab-0.16 )
		cd_load?	( >=sys-libs/libstatgrab-0.16 )
		cd_memory?	( >=sys-libs/libstatgrab-0.16 )
		cd_swap?	( >=sys-libs/libstatgrab-0.16 )
		cd_users?	( >=sys-libs/libstatgrab-0.16 )
	)"

DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig
	kernel_linux?	(
		cd_vserver?	( sys-kernel/vserver-sources )
	)"

RDEPEND="${COMMON_DEPEND}
	cd_syslog?		( virtual/logger )"

collectd_plugin_kernel_linux() {
	#
	# USAGE: <plug-in name> <kernel_options> <severity>
	# kernel_options is a list of kernel configurations options; the check tests whether at least
	#   one of them is enabled.
	#
	local multi_opt
	if use cd_${1}; then
		for opt in ${2}; do
			if linux_chkconfig_present ${opt}; then return 0; fi
		done
		multi_opt=${2//\ /\ or\ }
		case ${3} in
			(info)
				elog "The ${1} plug-in\tcan use features enabled by\t${multi_opt}\tin your kernel"
			;;
			(warn)
				ewarn "The ${1} plug-in\tuses features enabled by\t${multi_opt}\tin your kernel"
			;;
			(error)
				eerror "The ${1} plug-in\tneeds features enabled by\t${multi_opt}\tin your kernel"
			;;
			(*)
				die "function collectd_plugin_kernel_linux called with invalid third argument"
			;;
		esac
	fi
}

collectd_linux_kernel_checks() {
	linux-info_pkg_setup

	elog

	# battery.c:/proc/pmu/battery_%i
	# battery.c:/proc/acpi/battery
	collectd_plugin_kernel_linux battery PROC_FS warn
	collectd_plugin_kernel_linux battery ACPI_BATTERY warn

	# cpu.c:/proc/stat
	collectd_plugin_kernel_linux cpu PROC_FS warn

	# cpufreq.c:/sys/devices/system/cpu/cpu%d/cpufreq/
	collectd_plugin_kernel_linux cpufreq SYSFS warn
	collectd_plugin_kernel_linux cpufreq CPU_FREQ_STAT warn

	# utils_mount.c:/proc/partitions
	collectd_plugin_kernel_linux df PROC_FS warn

	# disk.c:/proc/diskstats
	# disk.c:/proc/partitions
	collectd_plugin_kernel_linux disk PROC_FS warn

	# entropy.c:/proc/sys/kernel/random/entropy_avail
	collectd_plugin_kernel_linux entropy PROC_FS warn

	# hddtemp.c:/proc/partitions
	collectd_plugin_kernel_linux hddtemp PROC_FS info

	# interface.c:/proc/net/dev
	collectd_plugin_kernel_linux interface PROC_FS warn
	collectd_plugin_kernel_linux ipmi IPMI_HANDLER warn
	collectd_plugin_kernel_linux ipvs IP_VS warn

	# irq.c:/proc/interrupts
	collectd_plugin_kernel_linux irq PROC_FS warn

	# load.c:/proc/loadavg
	collectd_plugin_kernel_linux load PROC_FS warn

	# memory.c:/proc/meminfo
	collectd_plugin_kernel_linux memory PROC_FS warn

	# nfs.c:/proc/net/rpc/nfs
	# nfs.c:/proc/net/rpc/nfsd
	collectd_plugin_kernel_linux nfs PROC_FS warn
	collectd_plugin_kernel_linux nfs NFS_COMMON warn

	# processes.c:/proc/%i/task
	# processes.c:/proc/%i/stat
	collectd_plugin_kernel_linux processes PROC_FS warn

	# serial.c:/proc/tty/driver/serial
	# serial.c:/proc/tty/driver/ttyS
	collectd_plugin_kernel_linux serial PROC_FS warn
	collectd_plugin_kernel_linux serial SERIAL_CORE warn

	# swap.c:/proc/meminfo
	collectd_plugin_kernel_linux swap PROC_FS warn
	collectd_plugin_kernel_linux swap SWAP warn

	# tcpconns.c:/proc/net/tcp
	# tcpconns.c:/proc/net/tcp6
	collectd_plugin_kernel_linux tcpconns PROC_FS warn

	# thermal.c:/proc/acpi/thermal_zone
	# thermal.c:/sys/class/thermal
	collectd_plugin_kernel_linux thermal "PROC_FS SYSFS" warn
	collectd_plugin_kernel_linux thermal ACPI_THERMAL warn

	# vmem.c:/proc/vmstat
	collectd_plugin_kernel_linux vmem PROC_FS warn
	collectd_plugin_kernel_linux vmem VM_EVENT_COUNTERS warn

	# vserver.c:/proc/virtual
	collectd_plugin_kernel_linux vserver PROC_FS warn

	# uuid.c:/sys/hypervisor/uuid
	collectd_plugin_kernel_linux uuid SYSFS info

	# wireless.c:/proc/net/wireless
	collectd_plugin_kernel_linux wireless PROC_FS warn
	collectd_plugin_kernel_linux wireless "MAC80211 IEEE80211" warn

	elog
}

pkg_setup() {
	elog
	elog "The following plug-ins are in general not supported by this ebuild (e.g. because"
	elog "Gentoo does not provide required dependencies):"
	for plugin in ${COLLECTD_DISABLED_PLUGINS}; do
		elog "${plugin}"
	done
	elog

	if use kernel_linux; then
		elog "Checking your linux kernel configuration..."
		collectd_linux_kernel_checks
		elog "... done."
	fi
}

src_prepare() {
	# There's some strange prefix handling in the default config file, resulting in 
	# paths like "/usr/var/..."
	sed -i -e "s:@prefix@/var:/var:g" src/collectd.conf.in || die
}

src_configure() {
	# Now come the lists of os-dependent plugins. Any plugin that is not listed anywhere here
	# should work independent of the operating system.

	local linux_plugins="battery cpu cpufreq disk entropy interface iptables ipvs irq load
		memory netlink nfs processes serial swap tcpconns thermal users vmem vserver
		wireless"

	local libstatgrab_plugins="cpu disk interface load memory swap users"
	local bsd_plugins="cpu tcpconns ${libstatgrab_plugins}"

	local darwin_plugins="apple_sensors battery cpu disk interface memory processes tcpconns"

	local osdependent_plugins="${linux_plugins} ${bsd_plugins} ${darwin_plugins}"
	local myos_plugins=""
	if use kernel_linux; then
		einfo "Enabling Linux plugins."
		myos_plugins=${linux_plugins}
	elif use kernel_FreeBSD; then
		einfo "Enabling FreeBSD plugins."
		myos_plugins=${bsd_plugins}
	elif use kernel_Darwin; then
		einfo "Enabling Darwin plugins."
		myos_plugins=${darwin_plugins}
	fi

	# Do we debug?
	local myconf="$(use_enable debug)"

	# Disable what needs to be disabled.
	for plugin in ${COLLECTD_DISABLED_PLUGINS}; do
		myconf="${myconf} --disable-${plugin}"
	done

	# Set enable/disable for each single plugin.
	for plugin in ${COLLECTD_PLUGINS}; do
		if has ${plugin} ${osdependent_plugins}; then
			# plugin is os-dependent ...
			if has ${plugin} ${myos_plugins}; then
				# ... and available in this os
				myconf="${myconf} $(use_enable cd_${plugin} ${plugin})"
			else
				# ... and NOT available in this os
				if use cd_${plugin}; then
					ewarn "You try to enable the ${plugin} plugin, but it is not available for this"
					ewarn "kernel. Disabling it automatically."
				fi
				myconf="${myconf} --disable-${plugin}"
			fi
		else
			myconf="${myconf} $(use_enable cd_${plugin} ${plugin})"
		fi
	done

	# Finally, run econf.
	KERNEL_DIR="${KERNEL_DIR}" econf --config-cache --without-included-ltdl --localstatedir=/var ${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die

	fixlocalpod

	dodoc AUTHORS ChangeLog NEWS README TODO || die

	if use contrib ; then
		insinto /usr/share/doc/${PF}
		doins -r contrib || die
	fi

	keepdir /var/lib/${PN} || die

	newinitd "${FILESDIR}/${PN}.initd" ${PN} || die
	newconfd "${FILESDIR}/${PN}.confd" ${PN} || die
}

collectd_rdeps() {
	use cd_${1} \
	&& elog "The ${1} plug-in\tneeds\t${2}\tto be installed localy or remotely to work."
}

pkg_postinst() {
	collectd_rdeps apcups sys-power/apcupsd
	collectd_rdeps hddtemp app-admin/hddtemp
	collectd_rdeps mbmon sys-apps/xmbmon
	collectd_rdeps memcached ">=net-misc/memcached-1.2.2-r2"
	collectd_rdeps ntpd net-misc/ntp
	collectd_rdeps openvpn ">=net-misc/openvpn-2.0.9"
}
