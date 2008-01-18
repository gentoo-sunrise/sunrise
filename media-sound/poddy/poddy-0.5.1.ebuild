# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="a lightweight command-line podcast client"
HOMEPAGE="http://ndan.ath.cx/poddy"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~ppc ~x86 ~x86-fbsd"
IUSE=""

DEPEND=">=dev-python/feedparser-4.1
	>=dev-python/urlgrabber-2.9.6
	>=dev-python/pysqlite-2.3"

RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}
