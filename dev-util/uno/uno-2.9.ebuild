# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A simple tool for source code analysis"
HOMEPAGE="http://spinroot.com/uno/"
SRC_URI="http://spinroot.com/${PN}/${PN}_v${PV/./}.tar.gz"

LICENSE="public-domain GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/${PV}-makefile.patch"
}

src_compile() {
	cd "${S}/src"
	emake || die "emake failed"
}

src_install() {
	dobin src/uno src/uno_local src/uno_global
	doman doc/uno.1
	insinto "/usr/share/doc/${PF}"
	doins doc/uno_long.pdf doc/uno_short.pdf
	insinto "/usr/share/${PN}"
	doins -r prop
}
