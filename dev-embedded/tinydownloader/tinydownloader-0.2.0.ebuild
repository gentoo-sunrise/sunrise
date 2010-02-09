# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Command Line Tool for downloading PIC code to 16Fxxx Tiny Bootloader"
HOMEPAGE="http://tuomas.kulve.fi/projects/tinydownloader/"
SRC_URI="http://tuomas.kulve.fi/debian/pool/etch/${PN}/t/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS README TODO debian/changelog || die
	doman tinydownloader.1 || die
}
