# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="An easy to use C/C++ seam carving library"
HOMEPAGE="http://liblqr.wikidot.com/"
SRC_URI="http://liblqr.wikidot.com/local--files/en:download-page/${PN}-1-${PV}.tar.bz2"

LICENSE="|| ( GPL-3 LGPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/glib"
DEPEND="${RDEPEND}"

S=$WORKDIR/${PN}-1-${PV}

src_install() {
	emake DESTDIR="${D}" install || die "emake intall failed"

	dodoc AUTHORS BUGS ChangeLog NEWS README TODO || die "dodoc failed"
}
