# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit distutils python

DESCRIPTION="A collection of useful extensions for Django"
HOMEPAGE="http://github.com/djblets"
SRC_URI="http://xmw.de/mirror/${PN}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-python/django
	dev-python/imaging"

src_prepare() {
	rm -r tests || die
	distutils_src_prepare
}
