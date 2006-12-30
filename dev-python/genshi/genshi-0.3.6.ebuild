# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

MY_PN=Genshi
MY_P=${MY_PN}-${PV}

DESCRIPTION="Python toolkit for stream-based generation of output for the web"
HOMEPAGE="http://genshi.edgewall.org"
SRC_URI="http://ftp.edgewall.com/pub/${PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}/${MY_P}

DOCS="INSTALL.txt README.txt UPGRADE.txt"

src_install(){

	distutils_src_install

	dohtml -r doc/*
	dodoc doc/*.txt
	insinto /usr/share/doc/${PF}
	doins -r examples || die "doins failed"
}

src_test() {
	${python} setup.py test || die "test failed"
}
