# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="simplified object-oriented Python extension module for libpcap"
HOMEPAGE="http://monkey.org/~dugsong/pypcap/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="net-libs/libpcap"
RDEPEND="${DEPEND}"

src_compile() {
	python setup.py config
	distutils_src_compile
}

src_install() {
	distutils_src_install
	dodoc README CHANGES
}
