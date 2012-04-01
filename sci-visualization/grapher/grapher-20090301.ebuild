# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Equation Grapher"
HOMEPAGE="http://homepages.nyu.edu/~ys453/#equation_grapher/"
SRC_URI="mirror://sourceforge/eqtn-${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/gtk+:2"
RDEPEND="${DEPEND}"
