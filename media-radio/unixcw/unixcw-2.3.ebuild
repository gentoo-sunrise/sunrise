# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A package of programs that fit together to form a morse code tutor program."
HOMEPAGE="http://radio.linux.org.au/?sectpat=morse"
SRC_URI="ftp://metalab.unc.edu/pub/Linux/apps/ham/morse/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""


src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-destdir.patch
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README || die "dodoc failed"
}
