# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON="2.4"

inherit distutils

DESCRIPTION="A python PostgreSQL introspective ORM"
HOMEPAGE="http://www.dbmother.org/"
SRC_URI="http://www.dbmother.org/download/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=">=dev-python/psycopg-2.0"

DOCS="AUTHORS doc/*"

src_install() {
	distutils_src_install

	insinto /usr/share/doc/${PF}/examples
	doins examples/*
}
