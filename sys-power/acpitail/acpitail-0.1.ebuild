# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="Shows in a tail-like way information of the battery-state, fan-states, temperatures."
HOMEPAGE="http://www.vanheusden.com/acpitail/"
SRC_URI="${HOMEPAGE}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-libs/libacpi"
DEPEND="${RDEPEND}"

src_compile() {
	emake \
		CC=$(tc-getCC) || \
		die "emake failed"
}

src_install() {
	dobin ${PN} || die "installation of ${PN} failed"
	dodoc readme.txt || die "nothing to read"
}
