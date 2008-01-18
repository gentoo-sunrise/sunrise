# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils linux-mod

DESCRIPTION="Experimental driver for RTL8187 and RTL818x wireless chipsets"
HOMEPAGE="http://rtl-wifi.sourceforge.net/"
SRC_URI="http://father.lugmen.org.ar/~aryix/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="!net-wireless/ieee80211"
RDEPEND="${DEPEND}
		net-wireless/wireless-tools"

MODULE_NAMES="ieee80211_crypt-rtl(net:ieee80211)
	ieee80211_crypt_wep-rtl(net:ieee80211)
	ieee80211_crypt_tkip-rtl(net:ieee80211)
	ieee80211_crypt_ccmp-rtl(net:ieee80211)
	ieee80211-rtl(net:ieee80211)
	r8180(net:rtl818x-newstack)
	r8187(net:rtl8187-newstack)"

BUILD_TARGETS="all"

pkg_setup() {
	if ! kernel_is 2 6 ; then
		eerror "This driver is for kernel >=2.6 only!"
		die "No kernel >=2.6 detected!"
	fi

	# Needs WIRELESS_EXT in kernel, for wireless_send_event
	local CONFIG_CHECK="WIRELESS_EXT CRYPTO CRYPTO_ARC4 CRC32 !IEEE80211"
	local ERROR_IEEE80211="${P} requires the in-kernel version of the IEEE802.11 subsystem to be disabled (CONFIG_IEEE80211)"
	linux-mod_pkg_setup
	BUILD_PARAMS="${KV_DIR} M=\${PWD}"
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
	elog "The r8188 module:			r8188"
	elog "The r8187 module:			r8187"
	elog "WEP and WPA encryption:	ieee80211_crypt-rtl"
	elog "WEP encryption:			ieee80211_crypt_wep-rtl"
	elog "WPA TKIP encryption:		ieee80211_crypt_tkip-rtl"
	elog "WPA CCMP encryption:		ieee80211_crypt_ccmp-rtl"
	elog "For the r8187 module:		ieee80211-rtl"
}
