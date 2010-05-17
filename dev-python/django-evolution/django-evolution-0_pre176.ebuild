# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit distutils python

DESCRIPTION="Allows to track changes in database models over time, and to update the db to reflect these"
HOMEPAGE="http://code.google.com/p/django-evolution/"
SRC_URI="http://xmw.de/mirror/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-python/django"

src_prepare() {
	rm -r tests || die
	distutils_src_prepare
}
