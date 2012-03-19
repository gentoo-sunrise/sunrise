# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
SUPPORT_PYTHON_ABIS="1"
PYTHON_DEPEND="*"

inherit distutils

DESCRIPTION="Selenium client bindings for Python"
HOMEPAGE="http://code.google.com/p/selenium/ http://pypi.python.org/pypi/selenium"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/setuptools"
RDEPEND=""

pkg_postinstall() {
	einfo "To use selenium with www-client/firefox-bin, you must create a "
	einfo "'firefox' symlink somewhere in your PATH."
	einfo "	 eg. ln -s /usr/bin/firefox-bin /usr/local/firefox"
}
