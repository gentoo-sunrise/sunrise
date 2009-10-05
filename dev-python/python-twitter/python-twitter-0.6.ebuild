# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="This library provides a pure python interface for the Twitter API"
HOMEPAGE="http://code.google.com/p/python-twitter/"
SRC_URI="http://python-twitter.googlecode.com/files/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

pkg_postinst() {
	python_version
	python_mod_optimize \
		/usr/$(get_libdir)/python${PYVER}/site-packages/python_twitter-${PV}-py${PYVER}.egg/
}

pkg_postrm() {
	python_mod_cleanup
}

