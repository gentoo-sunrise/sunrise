# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="PoddY is a command line tool for downloading podcasts"
HOMEPAGE="http://ndansmith.net/poddy.php"
SRC_URI="http://ndansmith.net/software/poddy/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

DEPEND="dev-python/feedparser"

RDEPEND=${DEPEND}

S="${WORKDIR}/${PN}"
