# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python{2_6,2_7} )
inherit eutils distutils-r1

DESCRIPTION="Python XMPP (RFC 3920,3921) and Jabber implementation"
HOMEPAGE="http://pyxmpp.jajcus.net/"
SRC_URI="http://pyxmpp.jajcus.net/downloads/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="dev-libs/libxml2[python,${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	dev-python/dnspython[${PYTHON_USEDEP}]
	dev-python/m2crypto[${PYTHON_USEDEP}]"

DOCS=( CHANGES ChangeLog README TODO )

src_install() {
	distutils-r1_src_install
	if use doc; then
		dohtml -r doc/www/*
	fi
}
