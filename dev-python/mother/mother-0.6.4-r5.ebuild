# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="An Object Relational Mapper with strong introspection"
HOMEPAGE="http://www.dbmother.org/"
SRC_URI="http://www.dbmother.org/download/${PF}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples +postgres sqlite"

RDEPEND="
	sqlite? ( dev-python/apsw )
	postgres? ( >=dev-python/psycopg-2.0 )"
DEPEND="${RDEPEND}"
RESTRICT_PYTHON_ABIS="3.*"

S=${WORKDIR}/${PF}

src_install() {
	distutils_src_install

	doman doc/mothermapper.1 || die

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/* || die
	fi

	if use doc; then
		dodoc doc/manual.* || die
	fi
}
