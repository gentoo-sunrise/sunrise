# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

KEYWORDS="~x86"

DESCRIPTION="Assembly level debugger"
HOMEPAGE="http://www.modest-proposals.com/Furball.htm"
SRC_URI="http://www.modest-proposals.com/binary/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
IUSE="ncurses readline"

DEPEND="ncurses? ( sys-libs/ncurses )
		readline? ( sys-libs/readline )"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e 's/ald/debug/g' \
		-e 's#$(BINDIR)#$(DESTDIR)/$(BINDIR)#' \
		-e 's#$(MANDIR)#$(DESTDIR)/$(MANDIR)#' \
		-e 's/\($(INSTALL_BIN)\)/\1 -D /' \
		-e 's/\($(INSTALL_DATA)\)/\1 -D /' \
		-e 's/-s//' \
		Makefile.in || die "sed failed"
}

src_compile() {
	CC=$(tc-getCC) econf \
		$(use_enable ncurses curses) \
		$(use_enable readline) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog README
}
