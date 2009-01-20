# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

DESCRIPTION="An ftps KIO slave for KDE"
HOMEPAGE="http://kasablanca.berlios.de/kio-ftps/"
SRC_URI="mirror://berlios/kasablanca/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

need-kde 3.5
S=${WORKDIR}/${P/a//}

DEPEND="|| ( kde-base/konqueror kde-base/kdebase )"
RDEPEND=${DEPEND}
