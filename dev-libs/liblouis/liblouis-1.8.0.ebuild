# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="An open-source braille translator and back-translator"
HOMEPAGE="http://code.google.com/p/liblouis/"
SRC_URI="http://liblouis.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc README AUTHORS NEWS ChangeLog || die
}
