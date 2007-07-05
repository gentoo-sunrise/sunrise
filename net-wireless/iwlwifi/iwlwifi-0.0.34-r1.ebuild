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

if kernel_is lt 2 6 22; then
	DEPEND="net-wireless/mac80211"
else
	CONFIG_CHECK="MAC80211"
fi

RDEPEND="net-wireless/iwlwifi-ucode"

S="${WORKDIR}/${P}/compatible"

MODULE_NAMES="iwl3945(net/wireless)"
BUILD_TARGETS="modules"

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="-C "${KV_DIR}" M="${S}" CONFIG_IWL3945=m"

	if kernel_is lt 2 6 22; then
		MY_INCLUDE="/usr/include/mac80211"
		MY_HEADERS="MAC80211_INC=/usr/include/mac80211/net/"
	else
		MY_INCLUDE="/usr/src/linux/"
		MY_HEADERS=""
	fi
}

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}/${P}"
	sed -i -e 's/\(.*chmod\)/#\1/' Makefile
	make compatible/kversion KSRC="${KV_DIR}" \
		${MY_HEADERS} || die "make unmodified failed"
	sed -i -e 's%\.\./\(net/mac80211/\)%\1%' "${S}"/*.c "${S}"/*.h
	echo "CFLAGS += -I${MY_INCLUDE} -DCONFIG_IWLWIFI_DEBUG=y" \
		"-DCONFIG_IWLWIFI_SPECTRUM_MEASUREMENT=y" >> "${S}"/Makefile
}

pkg_postinst()
{
	linux-mod_pkg_postinst
	elog
	elog "As for kernel version 2.6.22, iwlwifi uses the in-kernel"
	elog "version of mac80211"
	elog
}
