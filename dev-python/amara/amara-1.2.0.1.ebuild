# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils multilib

MY_PN=Amara
MY_P=${MY_PN}-${PV}
DESCRIPTION="Python tools for XML processing."
HOMEPAGE="http://uche.ogbuji.net/uche.ogbuji.net/tech/4suite/amara/"
SRC_URI="http://cheeseshop.python.org/packages/source/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.bz2"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc examples"

RDEPEND=">=dev-python/4suite-1.0.2
	dev-python/python-dateutil"
DEPEND="${RDEPEND}
		doc? ( dev-python/epydoc )"

S=${WORKDIR}/${MY_P}

DOCS="ACKNOWLEDGEMENTS CHANGES README TODO docs/quickref.txt"

src_install() {
	distutils_src_install

	dohtml manual.html

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r demo/*
	fi

	if use doc; then
		distutils_python_version
		export PYTHONPATH="${PYTHONPATH}:${D}/usr/$(get_libdir)/python${PYVER}/site-packages"
		epydoc amara
		dohtml -r html/*
	fi
}
