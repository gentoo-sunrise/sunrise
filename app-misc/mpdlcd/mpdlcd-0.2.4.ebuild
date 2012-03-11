# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
PYTHON_DEPEND="2:2.6"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.5 3.*"

inherit distutils

DESCRIPTION="Display MPD status on a lcdproc server"
HOMEPAGE="http://pypi.python.org/pypi/mpdlcd"
SRC_URI="mirror://pypi/m/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/lcdproc
	dev-python/python-mpd"
DEPEND="${RDEPEND}
	dev-python/setuptools"

DOCS="README"

src_install() {
	distutils_src_install

	doinitd initd/${PN}

	doman man/*

	insinto /etc
	doins ${PN}.conf
}
