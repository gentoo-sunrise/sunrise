# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

PYTHON_DEPEND="2:2.4"

inherit python distutils

DESCRIPTION="An Oracle enhanced client"
HOMEPAGE="http://pysql.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="graphviz"

DEPEND=">=dev-python/cx-oracle-5.0.2
	graphviz? (
		media-gfx/graphviz
		media-gfx/pydot
	)"
RDEPEND="${DEPEND}"

src_install() {
	distutils_src_install

	if [[ -d "${D}"/usr/share/pysql ]]; then
		rm -rf "${D}"/usr/share/pysql
	fi
}
