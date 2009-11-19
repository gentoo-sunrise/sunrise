# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="Python library that creates call graphs for Python programs"
HOMEPAGE="http://pycallgraph.slowchop.com/"
SRC_URI="http://${PN}.slowchop.com/files/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="media-gfx/graphviz"

RESTRICT_PYTHON_ABIS="3*"

src_install() {
	distutils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/* || die "Install failed"
	fi
}
