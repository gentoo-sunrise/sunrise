# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils toolchain-funcs vcs-snapshot

DESCRIPTION="An implementation of John Gruber's markdown in C"
HOMEPAGE="https://github.com/jgm/peg-markdown"
SRC_URI="https://github.com/jgm/${PN}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="|| ( GPL-2 MIT )"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-util/peg"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}/${P}-Makefile.patch" \
		"${FILESDIR}/${P}-declare.patch"
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	exeinto usr/bin
	doexe ${PN}
	dolib.so lib${PN}.so.${PV}
	dosym lib${PN}.so.${PV} usr/lib/lib${PN}.so
	dohtml README.html
	insinto usr/include
	doins markdown_lib.h
}
