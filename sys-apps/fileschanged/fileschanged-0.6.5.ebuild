# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Utility that reports when files have been altered"
HOMEPAGE="http://fileschanged.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="nls"

DEPEND="virtual/fam"

src_compile() {
	econf $(use_enable nls) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	# The Makefile doesn't install the docs in the right place and
	# doesn't compress them so we have to do things manually.
	dobin src/fileschanged
	doman man/fileschanged.1
	doinfo info/fileschanged.info
	dodoc ChangeLog README TODO
	emake -C po DESTDIR="${D}" install || die "emake -C po install failed"
}