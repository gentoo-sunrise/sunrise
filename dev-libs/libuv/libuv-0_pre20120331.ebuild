# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit multilib toolchain-funcs

DESCRIPTION="A new platform layer for Node"
HOMEPAGE="https://github.com/joyent/libuv"
SRC_URI="https://github.com/downloads/hasufell/tinkerbox/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_compile() {
	tc-export CC AR
	emake
}

src_install() {
	insinto /usr/include/${PN}
	doins -r include/*
	newlib.a uv.a ${PN}.a

	newdoc README.md README
}
