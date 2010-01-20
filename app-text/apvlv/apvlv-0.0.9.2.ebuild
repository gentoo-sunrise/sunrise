# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="PDF viewer with vim keybindings"
HOMEPAGE="http://code.google.com/p/apvlv/"
SRC_URI="http://apvlv.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="x11-libs/gtk+:2
	virtual/poppler-glib[cairo]"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		--with-mandir="/usr/share/man" \
		--disable-dependency-tracking \
		$(use_enable debug)
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS NEWS README THANKS || die
}
