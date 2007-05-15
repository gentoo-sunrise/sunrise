# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils linux-info linux-mod

DESCRIPTION="Experimental driver for RTL8187 and RTL818x wireless chipsets"
HOMEPAGE="http://rtl-wifi.sourceforge.net/"
SRC_URI="http://father.lugmen.org.ar/~aryix/distfiles/${PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
MY_PN="${WORKDIR}/${PN}-${PV}"
S=${WORKDIR}


MODULE_NAMES="ieee80211_crypt-rtl(net:${MY_PN}/ieee80211)
	ieee80211_crypt_wep-rtl(net:${MY_PN}/ieee80211)
	ieee80211_crypt_tkip-rtl(net:${MY_PN}/ieee80211)
	ieee80211_crypt_ccmp-rtl(net:${MY_PN}/ieee80211)
	ieee80211-rtl(net:${MY_PN}/ieee80211)
	r8180(net:${MY_PN}/rtl818x-newstack)"
BUILD_TARGETS="all"

pkg_setup() {
	if ! kernel_is 2 6 ; then
		eerror "This driver is for kernel >=2.6 only!"
		die "No kernel >=2.6 detected!"
	fi

	linux-info_pkg_setup
	linux-mod_pkg_setup

	# Needs NET_RADIO in kernel, for wireless_send_event
	local CONFIG_CHECK="NET_RADIO CRYPTO CRYPTO_ARC4 CRC32 !IEEE80211"
	local ERROR_IEEE80211="${P} requires the in-kernel version of the IEEE802.11 subsystem to be disabled (CONFIG_IEEE80211)"
	check_extra_config
}

src_install() {
	linux-mod_src_install

	dodoc ChangeLog

	# Further documentation
	local d f
	for d in ieee80211 rtl818x-newstack ; do
		docinto "${d}"
		for f in AUTHORS CHANGES README{,.adhoc,.master} ; do
			[[ -e "${d}/${f}" ]] && dodoc "${d}/${f}"
		done
	done
}

pkg_postinst() {
	linux-mod_pkg_postinst

	elog "You may want to add the following modules to"
	elog "/etc/modules.autoload.d/kernel-2.6"
	elog
	elog "The module itself:	   r8180"
	elog "WEP and WPA encryption:  ieee80211_crypt-rtl"
	elog "WEP encryption:		   ieee80211_crypt_wep-rtl"
	elog "WPA TKIP encryption:	   ieee80211_crypt_tkip-rtl"
	elog "WPA CCMP encryption:	   ieee80211_crypt_ccmp-rtl"
	elog "For the r8187 module:	   ieee80211-rtl"
}
