# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="a lightweight command-line podcast client"
HOMEPAGE="http://ndansmith.net/poddy.php"
SRC_URI="mirror://sourceforge/poddy/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

DEPEND="dev-python/feedparser
	dev-python/urlgrabber"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"
