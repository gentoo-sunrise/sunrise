# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit linux-mod

DESCRIPTION="mac80211 subsystem"
HOMEPAGE="http://intellinuxwireless.org/?p=mac80211"
SRC_URI="http://intellinuxwireless.org/${PN}/downloads/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

MOD="${P}"
S="${WORKDIR}/${MOD}/compatible/net"

MODULE_NAMES="mac80211(net/mac80211:${S}/mac80211) rc80211_simple(net/mac80211:${S}/mac80211) cfg80211(net/wireless:${S}/wireless)"
BUILD_TARGETS="modules"
CONFIG_CHECK="NET_SCHED WIRELESS_EXT LEDS_TRIGGERS"

pkg_setup() {
	if kernel_is ge 2 6 22 ; then
		CONFIG_CHECK="${CONFIG_CHECK} !MAC80211"
		ERROR_MAC80211="MAC80211 support already enabled in kernel. You do not need this ebuild."
	fi

	linux-mod_pkg_setup
	BUILD_PARAMS="CONFIG_MAC80211_LEDS=y CONFIG_MAC80211=m CONFIG_CFG80211=m
		-C ${KV_DIR} M=\${PWD}"
}

src_unpack() {
	unpack ${A}

	cd "${WORKDIR}"/${MOD}
	make unmodified KSRC="${KV_DIR}" || die "make unmodified failed"
	for i in "${S}"/mac80211 "${S}"/wireless ; do
		echo "CFLAGS += -I${WORKDIR}/${MOD}/compatible/include" \
			"-DCONFIG_MAC80211_LEDS=y" >> $i/Makefile
	done
}

src_install() {
	cd "${WORKDIR}"/${MOD}/compatible
	for i in include/net include/linux ; do
		insinto /usr/include/${i/include/mac80211}
		doins $i/*.h
	done

	insinto /usr/include/mac80211/net/mac80211
	doins net/mac80211/*.h

	linux-mod_src_install
}
