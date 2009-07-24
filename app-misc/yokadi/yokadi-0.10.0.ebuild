# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit distutils versionator

DESCRIPTION="Command line oriented, sqlite powered, todo list system"
HOMEPAGE="http://yokadi.github.com/index.html"
SRC_URI="http://yokadi.github.com/download/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# DEPEND specified by distutils.eclass
RDEPEND="${DEPEND}
	|| (
		>=dev-lang/python-2.5[sqlite]
		>=dev-python/pysqlite-2.5.5
	)
	dev-python/python-dateutil
	>=dev-python/sqlobject-0.9"

S=${WORKDIR}/${PN}-$(get_version_component_range 1-2)
