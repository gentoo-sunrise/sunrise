# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils eutils

DESCRIPTION="Python bindings for Graphviz"
HOMEPAGE="http://yapgvb.sourceforge.net/"
SRC_URI="mirror://sourceforge/yapgvb/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=dev-lang/python-2.4
	>=media-gfx/graphviz-2.6"
DEPEND="${RDEPEND}
	dev-libs/boost"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/boost_include_path.patch
}

src_install() {
	distutils_src_install
	doenvd "${FILESDIR}"/90graphviz
}
