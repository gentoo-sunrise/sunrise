# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Synchronize an ical calendar file with a Palm device DateBookDB database"
SRC_URI="http://hopf.math.northwestern.edu/syncal/${P}.tar.gz"
HOMEPAGE="http://hopf.math.northwestern.edu/syncal/"

KEYWORDS="~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="app-pda/pilot-link"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/Makefile.patch"
}

src_install() {
	emake INSTALLTOP="${D}/usr" install || die "emake install failed"
	dodoc README.Japanese README.ical.patch changelog
	dohtml syncal.man.html
	docinto ical
	dodoc ical.patch user.tcl
}
