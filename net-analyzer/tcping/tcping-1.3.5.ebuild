# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="Ping implementation that uses the TCP protocol"
HOMEPAGE="http://www.linuxco.de/tcping/tcping.html"
SRC_URI="http://www.linuxco.de/tcping/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

src_prepare() {
	sed -i -e '/^CC/d' \
		-e 's/$(CCFLAGS)/$(CFLAGS) $(LDFLAGS)/' \
		Makefile || die "sed Makefile failed"
}

src_compile() {
	tc-export CC
	default
}

src_install() {
	dobin tcping
	dodoc README
}
