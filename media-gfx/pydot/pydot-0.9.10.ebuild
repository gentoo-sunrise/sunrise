# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Python bindings for Graphviz"
HOMEPAGE="http://dkbza.org/"
SRC_URI="http://dkbza.org/data/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="dev-python/pyparsing
	media-gfx/graphviz"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/pydot-quote.patch
}
