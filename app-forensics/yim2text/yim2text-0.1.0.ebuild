# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.3

inherit distutils

DESCRIPTION="A python script to decode yahoo instant message archive files."
HOMEPAGE="http://www.1vs0.com/tools.html"
SRC_URI="http://www.1vs0.com/code/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	distutils_src_install
	doman ${PN}.man.1
}
