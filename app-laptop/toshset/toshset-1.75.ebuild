# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Utility to modify HCI/SCI controls on Toshiba Laptops"
HOMEPAGE="http://www.schwieters.org/toshset/"
SRC_URI="http://dev.gentooexperimental.org/~hwoarang/distfiles/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND=""
RDEPEND=""

src_prepare() {
	sed -i 's/CFLAGS = -march=i486 \(-Wall @OS_CFLAGS@ @DEBUGFLAGS@\)/CFLAGS := \1 ${CFLAGS}/' "${S}/Makefile.in" || die "sed failed"
}

src_configure(){
	econf $(use_enable debug)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README || die
}
