# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Nigel's Monitor - provided by IBM"
HOMEPAGE="http://nmon.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/lmon${PV}.c
		mirror://sourceforge/${PN}/makefile -> ${P}_makefile"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~ppc ~ppc64 ~amd64"
IUSE=""

DEPEND="sys-libs/ncurses
		sys-apps/lsb-release"
RDEPEND="${DEPEND}"

src_unpack () {
	cp ${DISTDIR}/lmon${PV}.c ${WORKDIR}/lmon.c
	cp ${DISTDIR}/${P}_makefile ${WORKDIR}/makefile
	echo 'nmon_gentoo:' >> ${WORKDIR}/makefile
	echo '	cc -o nmon $(FILE) $(CFLAGS) $(LDFLAGS)' "${CFLAGS}" >> ${WORKDIR}/makefile
}

src_compile() {
    emake nmon_gentoo || die "emake failed"
}

src_install() {
	dobin nmon
}
