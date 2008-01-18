# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A utility to transfer tracks, routes and waypoints to and from garmin GPS devices."
HOMEPAGE="http://pc12-c714.uibk.ac.at/gpspoint/"
SRC_URI="http://pc12-c714.uibk.ac.at/gpspoint/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-util/dialog"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-gcc41.patch"
}

src_install() {
	make DESTDIR="${D}" install || die "installation failed"
	dodoc AUTHORS NEWS README TODO
}

pkg_postinst() {
	elog
	elog "Be sure and set the GPSPORT environment variable in your shell"
	elog "or in /etc/profile.env if your gps is connected to a serial port"
	elog "other than /dev/ttyS0 (COM1)."
	elog "Alternatively you can make a link from /dev/gps to e.g. /dev/ttyS0."
	elog "gpspoints needs rw access on that device to work properly."
	elog
}
