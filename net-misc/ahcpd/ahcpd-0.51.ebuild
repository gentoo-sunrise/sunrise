# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="Daemon for configuring a network using AHCP"
HOMEPAGE="http://www.pps.jussieu.fr/~jch/software/ahcp/"
SRC_URI="http://www.pps.jussieu.fr/~jch/software/files/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_compile() {
	emake CC="$(tc-getCC)" CDEBUGFLAGS="${CFLAGS}" || die
}

src_install(){
	emake install PREFIX=/usr TARGET="${D}" || die
	dodoc CHANGES README || die
}
