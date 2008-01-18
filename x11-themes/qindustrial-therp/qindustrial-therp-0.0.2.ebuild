# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ARTS_REQUIRED="never"
inherit eutils kde
DESCRIPTION="A port for Qt of the Industrial GTK theme"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=22913"
SRC_URI="http://clemens.endorphin.org/qindustrial/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""

IUSE=""
need-kde 3.5
