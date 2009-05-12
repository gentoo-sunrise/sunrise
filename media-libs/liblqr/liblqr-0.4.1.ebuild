# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="An easy to use C/C++ seam carving library"
HOMEPAGE="http://liblqr.wikidot.com/"
SRC_URI="http://liblqr.wikidot.com/local--files/en:download-page/${PN}-1-${PV}.tar.bz2"

LICENSE="|| ( GPL-3 LGPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="dev-libs/glib"
DEPEND="${RDEPEND}"

S=$WORKDIR/${PN}-1-${PV}

src_configure() {
	econf $(use_enable doc install-man)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO || die "dodoc failed"
}
