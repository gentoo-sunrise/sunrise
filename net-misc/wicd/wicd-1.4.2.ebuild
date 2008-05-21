# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A wired and wireless network manager for Linux"
HOMEPAGE="http://wicd.sourceforge.net/"
MY_P="${PN}_${PV}-src"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"
LICENSE="GPL-2"

IUSE=""
KEYWORDS="~x86 ~amd64"
SLOT="0"

DEPEND=""
RDEPEND="dev-python/dbus-python
	dev-python/pygtk
	net-misc/dhcp
	net-wireless/wireless-tools
	net-wireless/wpa_supplicant
	sys-apps/ethtool
	"

src_install() {
	mv "${WORKDIR}"/* "${D}" || die "Copy failed"
	newinitd "${FILESDIR}/${P}-init.d wicd"
}

pkg_postinst() {
	elog "Make sure dbus is in the same runlevel"
	elog "as the wicd initscript"
	elog
	elog "Start the WICD GUI using:"
	elog "    /opt/wicd/gui.py"
	elog
	elog "Display the tray icon by running:"
	elog "    /opt/wicd/tray.py"
}
