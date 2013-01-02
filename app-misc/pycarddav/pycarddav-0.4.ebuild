# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"
PYTHON_DEPEND="2:2.6"
PYTHON_USE_WITH="sqlite"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

DESCRIPTION="A CardDAV based address book tool"
HOMEPAGE="http://lostpackets.de/pycarddav/"
SRC_URI="https://lostpackets.de/pycarddav/downloads/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE=""

DEPEND="dev-python/lxml
	dev-python/requests
	dev-python/setuptools
	dev-python/urwid
	dev-python/vobject
	virtual/python-argparse"
RDEPEND="${DEPEND}"

DOCS="pycard.conf.sample README.rst CHANGELOG NEWS"

pkg_postinst() {
	ewarn "Copy and edit the supplied pycard.conf.sample file"
	ewarn "(default location is ~/.pycard/pycard.conf)."
	ewarn "Beware that only you can access this file,"
	ewarn "if you have untrusted users on your machine,"
	ewarn "since the password is stored in cleartext."
}
