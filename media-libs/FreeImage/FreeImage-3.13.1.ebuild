# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="${PN}${PV//./}"

DESCRIPTION="FreeImage is an library to support popular graphics image formats like PNG, BMP, JPEG, TIFF"
HOMEPAGE="http://freeimage.sourceforge.net/"
SRC_URI="mirror://sourceforge/freeimage/${MY_P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

S=${WORKDIR}/${PN}

src_install() {
	emake install DESTDIR="${D}" || die "install fail"
	dodoc README.linux || die "doc install fail"
}
