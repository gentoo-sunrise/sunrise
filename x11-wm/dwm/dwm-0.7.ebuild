# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

DESCRIPTION="a dynamic window manager for X11"
HOMEPAGE="http://www.10kloc.org/dwm/"
SRC_URI="http://10kloc.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="|| ( x11-libs/libX11 virtual/x11 )"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-config_mk.patch"
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	if [ -f /etc/${P}/config.h ]; then
		einfo "Using /etc/${P}/config.h"
		cp /etc/${P}/config.h "${S}/config.h"
	fi
	emake CC=$(tc-getCC) || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install || die "emake install failed"

	insinto /etc/${P}
	doins config.h

	dodoc README
}

pkg_postinst() {
	einfo "To customize ${PN} edit /etc/${P}/config.h"
	einfo "and re-emerge ${P}"
}
