# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

DESCRIPTION="Extract information from Bluetooth devices"
HOMEPAGE="http://www.pentest.co.uk"
SRC_URI="http://www.pentest.co.uk/src/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-wireless/bluez-libs
	sys-libs/ncurses
	dev-lang/perl
	dev-libs/libxml2"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Apply patch to strip -Wimplicit-function-dec
	epatch "${FILESDIR}"/${P}-configure.in.patch

	# Apply patch for moved DTD and oui.txt
	epatch "${FILESDIR}"/${P}-btscanner.xml.patch

	# Reconfigure
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	# Move DTD file
	dodir /usr/share/btscanner || die "dodir failed"
	mv "${D}"/etc/btscanner.dtd "${D}"/usr/share/btscanner
	mv "${D}"/usr/share/oui.txt "${D}"/usr/share/btscanner

	dodoc AUTHORS README USAGE || die "dodoc failed"
}
