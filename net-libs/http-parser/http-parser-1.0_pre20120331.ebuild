# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils multilib toolchain-funcs

DESCRIPTION="A parser for HTTP messages written in C. It parses both requests and responses"
HOMEPAGE="https://github.com/joyent/http-parser"
SRC_URI="https://github.com/downloads/hasufell/tinkerbox/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	# fix SONAME/LDFLAGS
	epatch "${FILESDIR}"/20120331-makefile.patch
}

src_compile() {
	tc-export CC
	emake library
}

src_install() {
	insinto /usr/include/${PN}
	doins http_parser.h
	newlib.so libhttp_parser.so libhttp_parser.so.1.0
	dosym libhttp_parser.so.1.0 /usr/$(get_libdir)/libhttp_parser.so.1
	dosym libhttp_parser.so.1.0 /usr/$(get_libdir)/libhttp_parser.so

	newdoc README.md README
}
