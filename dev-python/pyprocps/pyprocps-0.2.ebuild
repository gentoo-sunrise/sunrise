# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="This module parses the information in /proc on Linux systems and presents it."
HOMEPAGE="http://eli.criffield.net/pyprocps"
SRC_URI="http://eli.criffield.net/${PN}/${P}.tar.gz"

LICENSE="PSF-2.3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="${DEPEND}"

src_install() {
	distutils_src_install
	dodoc Changelog PKG-INFO README
}
