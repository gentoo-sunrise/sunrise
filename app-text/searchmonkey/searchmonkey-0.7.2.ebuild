# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Powerful text searches on Linux using regular expressions"
HOMEPAGE="http://searchmonkey.sourceforge.net/index.php/Main_Page"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.6"

DEPEND=${RDEPEND}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS ChangeLog INSTALL NEWS README
	make_desktop_entry searchmonkey searchmonkey /usr/share/searchmonkey/pixmaps/searchmonkey-32x32.png
}


