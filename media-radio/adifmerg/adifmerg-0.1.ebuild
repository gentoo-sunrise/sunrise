# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A small conversion and check utility for ADIF files"
HOMEPAGE="http://jaakko.home.cern.ch/jaakko/Soft/"
SRC_URI="http://jaakko.home.cern.ch/jaakko/Soft/${PN}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="dev-lang/perl"

S=${WORKDIR}/AdifMerg

src_install() {
	dobin adifmerg || die "dobin failed"
	docinto examples
	dodoc addqsoinfo calcpnts lqslget lqsoget || die "dodoc failed"
	insinto /usr/share/${PN}
	doins template.cab || die "doins failed"
	doman doc/adifmerg.1 || die "doman failed"
	dodoc CHANGELOG README || die "dodoc failed"
}

