# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

DESCRIPTION="A tool for analyzing the source code of programs written in ANSI-C"
HOMEPAGE="http://spinroot.com/uno/"
SRC_URI="http://spinroot.com/${PN}/${PN}_v${PV/./}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

DEPEND=""
RDEPEND=""

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/${PV}-makefile.patch"
}

src_compile() {
	cd "${S}/src"
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	dobin src/uno src/uno_local src/uno_global
	doman doc/uno.1

	insinto /usr/share/${PN}
	doins -r prop

	if use doc ; then
		insinto /usr/share/doc/${PF}
		doins doc/*.pdf
	fi
}
