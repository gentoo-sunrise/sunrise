# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="photomosaics generator"
HOMEPAGE="http://www.complang.tuwien.ac.at/~schani/metapixel/"
SRC_URI="http://www.complang.tuwien.ac.at/~schani/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="media-libs/jpeg
	media-libs/libpng"
RDEPEND="${DEPEND}
	dev-lang/perl"

src_install () {
	dodir /usr/share/man/man1
	emake PREFIX="${D}" BINDIR="${D}/usr/bin" \
		MANDIR="${D}/usr/share/man" install || die "emake install failed"
	dodoc NEWS README
}
