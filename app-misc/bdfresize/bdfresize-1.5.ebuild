# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

DESCRIPTION="A tool for resizing BDF format fonts"
HOMEPAGE="http://openlab.jp/efont/dist/tools/bdfresize/"
SRC_URI="http://openlab.jp/efont/dist/tools/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-gcc4.0.patch"
	AM_OPTS="--force-missing" eautoreconf
}

src_install() {
	dobin bdfresize || die
	doman bdfresize.1 || die
	dodoc ChangeLog AUTHORS README || die
}
