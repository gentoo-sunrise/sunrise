# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_PN="RemenDeKO"
DESCRIPTION="File corruption detection and repair program"
HOMEPAGE="http://rdko.sourceforge.net/"
SRC_URI="mirror://sourceforge/rdko/${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="gtk"
RESTRICT="strip"

RDEPEND="gtk? ( >=x11-libs/gtk+-2.4.0 )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.15"

S="${WORKDIR}/${MY_PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i \
		-e '/^CFLAGS =/s:-fmessage-length=0 -fexpensive-optimizations -O3:$(E_CFLAGS):' \
		-e '/^CFLAGSGUI/s:-fmessage-length=0 -fexpensive-optimizations -O3:$(CFLAGS):' \
		Makefile || die "sed Makefile failed"
}
src_compile() {
	if use gtk; then
		emake E_CFLAGS="${CFLAGS}"  || die "emake failed"
	else
		emake E_CFLAGS="${CFLAGS}" rdko || die "emake failed"
	fi
}

src_install() {
	dodoc CHANGELOG
	dobin rdko || die "dobin rdko failed"
	if use gtk; then
		dobin gredeko || die "dobin gredeko failed"
	fi
}
