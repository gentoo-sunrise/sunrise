# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils python

KEYWORDS="~x86"

MY_P=${P/sqla/SQLA}

DESCRIPTION="Python SQL toolkit and Object Relational Mapper that gives application developers the full power and flexibility of SQL."
HOMEPAGE="http://www.sqlalchemy.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="MIT"
SLOT="0"
IUSE="firebird mysql postgres sqlite test"

DEPEND="dev-python/setuptools"
RDEPEND="firebird? ( dev-python/kinterbasdb )
		mssql? ( dev-python/pymssql )
		mysql? ( dev-python/mysql-python )
		postgres? ( dev-python/psycopg
			dev-python/egenix-mx-base )
		sqlite? ( dev-python/pysqlite )
		test? ( dev-python/pysqlite )"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}

	cd "${S}/test"
	sed -i \
		-e 's/\\\.p/.p/g' \
		sql/testtypes.py || die "sed failed"
}

src_install() {
	distutils_src_install
	dohtml doc/*

	insinto /usr/share/${PN}
	doins -r examples
}

src_test() {
	python_version
	export PYTHONPATH="${PYTHONPATH}:../lib/"
	cd "${S}/lib/${PN}"
	python "/usr/lib/python${PYVER}/compileall.py" .
	cd "${S}/test"
	python alltests.py
}
