# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils eutils

MY_P=${P/icepy/IcePy}

DESCRIPTION="ICE middleware Python bindings"
HOMEPAGE="http://www.zeroc.com/index.html"
SRC_URI="http://www.zeroc.com/download/Ice/${PV%.?}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="examples"

DEPEND="~dev-cpp/ice-${PV}"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}

	cd "${S}"

	cp "${FILESDIR}"/${PN}-setup.py setup.py
	sed -i -e "s/ICEVERSION/${PV}/" setup.py

}

src_install() {
	distutils_src_install

	# installing additional documentation
	dohtml -r doc/*
	dodoc CHANGES

	insinto "/usr/share/${PN}"
	doins -r slice/
	find "${D}/usr/share/${PN}/slice" -iname Makefile -delete

	if use examples; then
		doins -r demo/
		doins -r certs/
	fi
}
