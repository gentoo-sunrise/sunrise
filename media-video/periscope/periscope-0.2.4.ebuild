# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2:2.6"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.[45] 3.*"

inherit distutils

DESCRIPTION="Python module for searching subtitles on the web"
HOMEPAGE="http://code.google.com/p/periscope/"
SRC_URI="http://periscope.googlecode.com/files/python-${PN}_${PV}.orig.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nautilus"

RDEPEND="dev-python/beautifulsoup
	nautilus? ( dev-python/nautilus-python
	dev-python/notify-python )"
DEPEND="${RDEPEND}
	dev-python/setuptools"

pkg_postinst() {
	elog "If you want to use Periscope as a Nautilus plugin, follow the instructions"
	elog "on this url: http://code.google.com/p/periscope/wiki/NautilusSupport"
}
