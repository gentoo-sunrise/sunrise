# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ARTS_REQUIRED="never"

inherit kde

DESCRIPTION="KDE frontend to Gentoo Portage"
HOMEPAGE="http://sourceforge.net/projects/kuroo"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"

SLOT="3.5"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="dev-db/sqlite"

RDEPEND="${DEPEND}
	app-portage/gentoolkit
	kde-misc/kdiff3
	kde-base/kdesu"

need-kde 3.5
