# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="Easy to use filesystem activity monitoring"
HOMEPAGE="http://mytty.org/fspy/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

src_compile() {
	local cc=$(tc-getCC)

	emake clean || die
	# LDFLAGS var is passed when compiling too...
	emake CC="${cc}" LD="${cc} ${LDFLAGS}" || die
}

src_install() {
	dobin fspy || die "failed to install fspy binary"
	dodoc README || die "failed to install documentation"
}
