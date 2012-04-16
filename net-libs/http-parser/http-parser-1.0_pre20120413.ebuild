# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils multilib toolchain-funcs

DESCRIPTION="A parser for HTTP messages written in C. It parses both requests and responses"
HOMEPAGE="https://github.com/joyent/http-parser"
SRC_URI="mirror://github/hasufell/tinkerbox/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/20120413-makefile.patch
}

src_compile() {
	tc-export CC
	emake library
}

src_install() {
	insinto /usr/include/${PN}
	doins http_parser.h
	dolib.so libhttp_parser.so
	newdoc README.md README
}
