# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit linux-mod

DESCRIPTION="Intel (R) PRO/Wireless 3945ABG Network Connection"
HOMEPAGE="http://intellinuxwireless.org/?p=iwlwifi"
SRC_URI="http://intellinuxwireless.org/${PN}/downloads/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=net-wireless/mac80211-8.0.1"
RDEPEND="net-wireless/iwlwifi-ucode"

S="${WORKDIR}/${P}/compatible"

MODULE_NAMES="iwl3945(net/wireless)"
BUILD_TARGETS="modules"

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="-C ${KV_DIR} M=${S} CONFIG_IWL3945=m"
}

src_unpack() {
	unpack ${A}
	cd ${P}
	sed -i -e 's/\(.*chmod\)/#\1/' Makefile
	make compatible/kversion KSRC="${KV_DIR}" \
		MAC80211_INC=/usr/include/mac80211/net/ || die "make unmodified failed"
	sed -i -e 's%\.\./\(net/mac80211/\)%\1%' "${S}"/*.c "${S}"/*.h
	echo "CFLAGS += -I/usr/include/mac80211 -DCONFIG_IWLWIFI_DEBUG=y" \
		"-DCONFIG_IWLWIFI_SPECTRUM_MEASUREMENT=y" >> "${S}"/Makefile
}
