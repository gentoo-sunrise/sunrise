# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="SCUBA dive logging application, with extendable plugin support."
HOMEPAGE="http://gdivelog.sourceforge.net/"
SRC_URI="mirror://sourceforge/gdivelog/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND="gnome-base/libgnomeui
	dev-db/sqlite"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
