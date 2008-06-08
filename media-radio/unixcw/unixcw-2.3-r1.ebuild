# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils

DESCRIPTION="A package of programs that fit together to form a morse code tutor program."
HOMEPAGE="http://radio.linux.org.au/?sectpat=morse"
SRC_URI="ftp://metalab.unc.edu/pub/Linux/apps/ham/morse/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="ncurses qt3"

RDEPEND="ncurses? ( sys-libs/ncurses )
	qt3? ( =x11-libs/qt-3* )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-destdir.patch
	epatch "${FILESDIR}"/${P}-config.patch
	eautoreconf
}

src_compile() {
	econf $(use_enable ncurses) \
		$(use_enable qt3)
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README || die "dodoc failed"
}
