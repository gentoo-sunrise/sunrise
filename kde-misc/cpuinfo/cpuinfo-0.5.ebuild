# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

KEYWORDS="~x86"

DESCRIPTION="Small kicker applet for KDE 3.x which shows the current CPU temperature and frequency."
HOMEPAGE="http://kde-apps.org/content/show.php?content=33257"
SRC_URI="http://www.elliptique.net/~ken/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE="kdeenablefinal"

need-kde 3

DEPEND=""
RDEPEND=""

src_compile() {
	myconf="$(use_enable kdeenablefinal final)"
	kde_src_compile
}
