# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="Daemon turns other process into daemons, respawning automatically"
HOMEPAGE="http://www.libslack.org/daemon/"
SRC_URI="http://libslack.org/daemon/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-amd64 ~x86"
IUSE=""
RESTRICT="test"

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e '/strip/d' rules.mk
}

src_compile() {
	./config
	emake CC="$(tc-getCC)" AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)" \
		CCFLAGS="${CFLAGS}" PREFIX="/usr" || die "emake failed"
}

src_install() {
	emake PREFIX="${D}/usr" install || die "emake install failed"
	dodoc README
}
