# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic db db-use distutils

DESCRIPTION="BerkeleyDB XML, a native XML database from the BerkeleyDB team"
HOMEPAGE="http://www.oracle.com/database/berkeley-db/xml/index.html"
SRC_URI="http://download-east.oracle.com/berkeley-db/${P}.tar.gz
	http://download-west.oracle.com/berkeley-db/${P}.tar.gz
	http://download-uk.oracle.com/berkeley-db/${P}.tar.gz
	http://www.oracle.com/technology/products/berkeley-db/xml/update/2.3.10/patch.2.3.10.3"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc python"

DEPEND=">=sys-libs/db-4.3.28
	~dev-libs/xerces-c-2.7.0
	>=dev-libs/xqilla-1.0.1
	python? (
		>=dev-lang/python-2.3
		>=dev-python/bsddb3-4.5.0 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/dbxml"

src_unpack() {
	unpack ${P}.tar.gz

	cd ${P}
	epatch "${DISTDIR}/patch.2.3.10.3"
	epatch "${FILESDIR}/dbxml-pythonfixes.patch"

	cd ${S}
	#Tell the configure script where our db version is
	db_version="$(db_findver sys-libs/db)" || die "Couldn't find db"
	db_incpath="$(db_includedir)"          || die "Couldn't find db include path"
	sed -i -e "s:db_version=.*:db_version=${db_version}:" dist/configure && \
		sed -i -e "s:GENTOODBINCPATH:${db_incpath}:" src/python/setup.py.in && \
		sed -i -e "s:GENTOODB_CXX:db_cxx-${db_version}:" src/python/setup.py.in || \
		die "Sed failed"
}

src_compile() {
	cd build_unix

	append-flags -I$(db_includedir) #Needed despite db_version stuff above
	ECONF_SOURCE=../dist
	econf --with-berkeleydb=/usr --with-xqilla=/usr --with-xerces=/usr
	emake -j1 || die "emake failed"
	if use python ; then
		einfo "Compiling python extension"
		cd ${S}/src/python
		distutils_src_compile
	fi
}

src_install() {
	cd build_unix

	#Install fails with emake
	einstall || die "einstall failed"
	db_src_install_doc

	if use python ; then
		einfo "Installing python extension"
		cd ${S}/src/python
		distutils_src_install
	fi
}
