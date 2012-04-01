# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit toolchain-funcs

MY_PN="RemenDeKO"
DESCRIPTION="File corruption detection and repair program"
HOMEPAGE="http://rdko.sourceforge.net/"
SRC_URI="mirror://sourceforge/rdko/${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="gtk"

RDEPEND="gtk? ( x11-libs/gtk+:2 )"
DEPEND="${RDEPEND}
	gtk? ( >=dev-util/pkgconfig-0.15 )"

S=${WORKDIR}/${MY_PN}

src_prepare() {
	sed -i \
		-e 's: -s::g' \
		-e 's:$(CC) $(LINKOBJ:$(CC) $(LDFLAGS) $(LINKOBJ:g' \
		-e "s:^\(CC   = \).*$:\1$(tc-getCC):" \
		-e "s:^\(CFLAGS = \).*$:\1${CFLAGS} -Wall:" \
		Makefile || die "sed Makefile failed"

	if use gtk;	then
		sed -i \
			-e "s:^\(CFLAGSGUI = \).*$:\1${CFLAGS} -DUSEGUI -Wall \
				`pkg-config gtk+-2.0 gthread-2.0 --cflags`:" \
			Makefile || die "sed Makefile failed"
	else
		sed -i \
			-e "s:^\(CFLAGSGUI = \).*$:\1${CFLAGS} -Wall:" \
			Makefile || die "sed Makefile failed"
	fi
}

src_compile() {
	if use gtk; then
		emake || die "emake failed"
	else
		emake rdko || die "emake rdko failed"
	fi
}

src_install() {
	dobin rdko
	use gtk && dobin gredeko
	dodoc CHANGELOG
}
