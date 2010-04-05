# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit toolchain-funcs

DESCRIPTION="Nigel's Monitor - provided by IBM"
HOMEPAGE="http://nmon.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/lmon${PV}.c"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}"

src_unpack() {
	cp "${DISTDIR}"/lmon${PV}.c "${WORKDIR}"/lmon.c || die "cp failed"
	cp "${FILESDIR}/${P}_makefile" "${WORKDIR}"/makefile || die "cp failed"
}

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	dobin nmon || die "dobin failed"
}
