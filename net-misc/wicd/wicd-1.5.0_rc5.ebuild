# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

MY_P="${P/_rc/rc}"
DESCRIPTION="A wired and wireless network manager for Linux"
HOMEPAGE="http://wicd.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="dev-python/dbus-python
	dev-python/pygtk
	net-misc/dhcp
	net-wireless/wireless-tools
	net-wireless/wpa_supplicant
	sys-apps/ethtool"

S="${WORKDIR}/${MY_P}"

src_compile() {
	${python} ./setup.py configure --no-install-init --resume=/usr/share/wicd/scripts/ --suspend=/usr/share/wicd/scripts/ --verbose
	distutils_src_compile
}

src_install() {
	distutils_src_install
	newinitd "${FILESDIR}/${P}-init.d" wicd
}

pkg_postinst() {
	distutils_pkg_postinst

	elog "Note: commands have changed since previous versions of WICD"
	elog "Start the WICD GUI using:"
	elog "    /usr/bin/wicd-client"
}
