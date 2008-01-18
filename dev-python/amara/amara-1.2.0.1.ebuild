# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.4

inherit distutils multilib

MY_PN=Amara
MY_P=${MY_PN}-${PV}

DESCRIPTION="Python tools for XML processing."
HOMEPAGE="http://uche.ogbuji.net/tech/4suite/amara/"
SRC_URI="http://cheeseshop.python.org/packages/source/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.bz2"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc examples"

RDEPEND=">=dev-python/4suite-1.0.2
	dev-python/python-dateutil"
DEPEND="${RDEPEND}
	dev-python/setuptools
	doc? ( dev-python/epydoc )"

S=${WORKDIR}/${MY_P}

src_compile() {
	distutils_src_compile
	if use doc ; then
		einfo "Generating docs as requested..."
		PYTHONPATH=./build/lib/ epydoc amara || die "generating docs failed"
	fi
}

src_install() {
	DOCS="ACKNOWLEDGEMENTS CHANGES docs/quickref.txt"
	distutils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r demo/*
	fi

	use doc && dohtml -r html/*
}
