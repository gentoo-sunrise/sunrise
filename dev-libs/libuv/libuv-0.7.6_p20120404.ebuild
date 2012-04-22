# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A new platform layer for Node"
HOMEPAGE="https://github.com/joyent/libuv"
SRC_URI="https://github.com/downloads/hasufell/tinkerbox/${P}.tar.gz"
# commit bf9a2b346306583d1eff9b14b3a2b85f9768cb83

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_compile() {
	tc-export CC AR
	append-flags -fno-strict-aliasing
	emake
}

src_install() {
	insinto /usr/include
	doins -r include/*
	newlib.a uv.a ${PN}.a

	newdoc README.md README
}
