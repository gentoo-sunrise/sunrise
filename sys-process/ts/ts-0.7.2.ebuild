# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="A comfortable way of running batch jobs"
HOMEPAGE="http://vicerveza.homeunix.net/~viric/soft/ts/"
SRC_URI="http://vicerveza.homeunix.net/~viric/soft/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# collision of /usr/bin/ts
RDEPEND="!sys-apps/moreutils
	!app-misc/timestamp"

src_prepare() {
	sed -i \
		-e 's|CFLAGS=|CFLAGS+=|' \
		-e 's|-g -O0||' \
		-e 's|$(LDFLAGS)|$(CFLAGS) &|' \
		Makefile || die "sed failed"
}

src_compile() {
	tc-export CC
	default
}

src_test() {
	sh testbench.sh || die "tests failed"
}

src_install() {
	emake PREFIX="${D}/usr" install
	dodoc Changelog OBJECTIVES PROTOCOL TRICKS
	dohtml web/index.html
}
