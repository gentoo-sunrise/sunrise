# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

KEYWORDS="~x86"

MY_P=${P/amara/Amara}

DESCRIPTION="Python tools for XML processing."
HOMEPAGE="http://uche.ogbuji.net/uche.ogbuji.net/tech/4suite/amara/"
SRC_URI="http://uche.ogbuji.net/tech/4suite/etc/${MY_P}.tar.bz2"
LICENSE="Apache-1.1"
SLOT="0"
IUSE="doc examples"

DEPEND=">=dev-python/4suite-1.0_beta2
		doc? ( dev-python/epydoc )"
RDEPEND=">=dev-python/4suite-1.0_beta2"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}

	cd "${S}"
	# We would get 'unknown module amara' if amara is not yet installed
	ln -s lib amara
}

src_install() {
	distutils_src_install

	dodoc ACKNOWLEDGEMENTS CHANGES README TODO quickref.txt
	dohtml manual.html

	if use doc; then
		epydoc build/lib/amara
		dohtml -r html/*
	fi

	if use examples; then
		insinto /usr/share/${PN}
		doins -r demo
	fi
}
