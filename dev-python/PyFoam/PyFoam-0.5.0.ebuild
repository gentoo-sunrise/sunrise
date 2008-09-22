# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Tool to analyze and plot the residual files of OpenFOAM computations"
HOMEPAGE="http://openfoamwiki.net/index.php/Contrib_PyFoam"
SRC_URI="http://openfoamwiki.net/images/0/01/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="${DEPEND}
	sci-visualization/gnuplot
	|| ( sci-libs/openfoam-meta sci-libs/openfoam sci-libs/openfoam-bin ) "
