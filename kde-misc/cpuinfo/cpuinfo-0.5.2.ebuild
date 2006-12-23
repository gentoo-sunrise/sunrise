# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

DESCRIPTION="Small kicker applet for KDE 3.x which shows the current CPU temperature and frequency."
HOMEPAGE="http://kde-apps.org/content/show.php?content=33257"
SRC_URI="http://www.elliptique.net/~ken/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kdeenablefinal"

DEPEND=""
RDEPEND=""

need-kde 3.3
