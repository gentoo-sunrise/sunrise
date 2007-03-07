# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic db db-use

DESCRIPTION="BerkeleyDB XML, a native XML database from the BerkeleyDB team"
HOMEPAGE="http://www.oracle.com/database/berkeley-db/xml/index.html"
SRC_URI="http://download-east.oracle.com/berkeley-db/${P}.tar.gz
	http://download-west.oracle.com/berkeley-db/${P}.tar.gz
	http://download-uk.oracle.com/berkeley-db/${P}.tar.gz"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

DEPEND=">=sys-libs/db-4.3.28
	=dev-libs/xerces-c-2.7.0*
	>=dev-libs/xqilla-1.0.1"
RDEPEND=$DEPEND

S="${WORKDIR}/${P}/dbxml"

src_unpack() {
	unpack ${A}

	#Tell the configure script where our db version is
	db_version="$(db_findver sys-libs/db)" || die "Couldn't find db"
	sed -i -e "s:db_version=.*:db_version=${db_version}:" "${S}/dist/configure" \
	    || die "Couldn't set db_version with sed"
}

src_compile() {
	cd build_unix

	append-flags -I$(db_includedir) #Needed despite db_version stuff above
	ECONF_SOURCE=../dist
	econf --with-berkeleydb=/usr --with-xqilla=/usr --with-xerces=/usr

	emake -j1 || die "make failed"
}

src_install() {
	cd build_unix
	#Install fails with emake
	einstall || die

	db_src_install_doc
}
