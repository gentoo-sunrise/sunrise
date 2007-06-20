# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Tntdb is a c++-class-library for easy and light database-access. Currently postgresql, sqlite3 and mysql are supported."
HOMEPAGE="http://www.tntnet.org/tntdb.hms"
SRC_URI="http://www.tntnet.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="mysql postgres sqlite"

RDEPEND="mysql? ( virtual/mysql )
	postgres? ( >=dev-db/postgresql-7 )
	sqlite? ( >=dev-db/sqlite-3 )
	>=dev-libs/cxxtools-1.4.3"
DEPEND="${RDEPEND}"

src_compile() {
	econf ${myconf} \
	  $(use_with mysql) \
	  $(use_with postgres postgresql) \
	  $(use_with sqlite) \
	  || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README NEWS doc/*.pdf
}
