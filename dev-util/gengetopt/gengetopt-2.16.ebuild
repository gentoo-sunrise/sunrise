# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="a tool to write option parsing code for C programs."
HOMEPAGE="http://www.gnu.org/software/gengetopt/"
SRC_URI="ftp://ftp.gnu.org/gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="examples"

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-tests_makefile_am.patch"
}

src_install() {
	cd "${S}/src"
	emake DESTDIR="${D}" install || die "emake install failed"

	cd "${S}"
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO

	cd "${S}/doc"
	dohtml *.html
	doinfo *.info
	if use examples; then
		docinto examples
		dodoc sample{1,2}.ggo main{1.cc,2.c} cmdline{1,2}.{c,h}
	fi
}
