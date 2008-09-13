# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Shows currently transmitting beacons of the International Beacon Project (IBP)"
HOMEPAGE="http://wwwhome.cs.utwente.nl/~ptdeboer/ham/${PN}.html"
SRC_URI="http://wwwhome.cs.utwente.nl/~ptdeboer/ham/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="X"

RDEPEND="sys-libs/ncurses
	X? ( x11-libs/libX11  )"
DEPEND="${RDEPEND}
	X? ( x11-misc/imake )"

src_compile() {
	if ( use X ) ;then
		xmkmf || die " xmkmf failed"
	fi
	emake || die "emake failed"
}

src_install() {
	dobin ${PN} || die "dobin failed"
	doman ${PN}.1
}
