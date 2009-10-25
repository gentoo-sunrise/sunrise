# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Python network library that uses greenlet and libevent for easy and scalable concurrency"
HOMEPAGE="http://gevent.org/"
SRC_URI="http://pypi.python.org/packages/source/g/gevent/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="doc examples"

DEPEND=">=dev-lang/python-2.5
	>=dev-python/greenlet-0.2
	dev-python/setuptools"
RDEPEND="${DEPEND}"

src_install() {
	distutils_src_install

	if use doc; then
		dodoc doc/* || die "dodoc failed"
	fi

	if use examples; then
		docinto examples 
		dodoc examples/* || die "dodoc failed"
	fi
}

