# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit latex-package

DESCRIPTION="Horizontal and vertical dashed lines in arrays and tabulars."
HOMEPAGE="http://tug.ctan.org/tex-archive/macros/latex/contrib/arydshln/"
SRC_URI="http://www.rennings.net/gentoo/distfiles/${P}.zip"

LICENSE="LPPL-1.3b"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}/${PN}
