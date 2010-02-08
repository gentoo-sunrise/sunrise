# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Modular search for django"
HOMEPAGE="http://haystacksearch.org"
SRC_URI="http://cloud.github.com/downloads/toastdriven/${PN}/${P}-final.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-python/django
	>=dev-python/Whoosh-0.3"

S=${WORKDIR}/${PN}
