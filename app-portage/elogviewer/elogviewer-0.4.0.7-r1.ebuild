# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Graphical utility to parse the contents of the elogs"
HOMEPAGE="http://forums.gentoo.org/viewtopic-p-3374725.html#3374725"
SRC_URI="http://www.rz-berlin.mpg.de/~laurin/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=">=dev-lang/python-2.3
>=dev-python/pygtk-2.0
>=sys-apps/portage-2.1"

src_install() {
	dobin "${WORKDIR}"/elogviewer 
	dodoc "${WORKDIR}"/CHANGELOG
}
