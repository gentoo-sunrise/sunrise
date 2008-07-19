# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Daemon to control the speed and voltage of CPUs"
HOMEPAGE="http://powerthend.scheissname.de/"
SRC_URI="http://dev.gentooexperimental.org/~tommy/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i "s:-O2:${CFLAGS}:" Makefile
}

src_compile() {
	emake powerthend || die "emake failed"
}

src_install() {
	dosbin powerthend || die "dosbin failed"
	dodoc README

	newconfd "${FILESDIR}/powerthend.confd" powerthend
	newinitd "${FILESDIR}/powerthend.rc" powerthend
}
