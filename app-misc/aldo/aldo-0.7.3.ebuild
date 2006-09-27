# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

DESCRIPTION="a morse tutor"
HOMEPAGE="http://savannah.nongnu.org/projects/aldo"
SRC_URI="http://savannah.nongnu.org/download/aldo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

DEPEND="virtual/libc
	>=media-libs/libao-0.8.5"
RDEPEND=${DEPEND}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc README AUTHORS ChangeLog NEWS THANKS
}

