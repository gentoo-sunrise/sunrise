# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="NativeBigInteger libs for Freenet taken from i2p"
HOMEPAGE="http://www.i2p.net"
SRC_URI="http://dev.gentooexperimental.org/~tommy/${P}.tar.bz2"

LICENSE="|| ( public-domain BSD MIT )"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-libs/gmp"
RDEPEND="${DEPEPND}"

append-flags -fPIC
tc-getCC >/dev/null

QA_TEXTRELS="opt/freenet/lib/libjcpuid-x86-linux.so"

src_compile() {
	cp "${FILESDIR}"/Makefile .
	make libjbigi || die
	filter-flags -fPIC
	make libjcpuid || die
}

src_install() {
	make DESTDIR="${D}" install || die
}
