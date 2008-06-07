# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools

DESCRIPTION="A c++-class-library for easy and light database-access. Currently for postgresql, sqlite3 and mysql"
HOMEPAGE="http://www.tntnet.org/tntdb.hms"
SRC_URI="http://www.tntnet.org/download/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc mysql postgres sqlite"

RDEPEND="mysql? ( virtual/mysql )
	postgres? ( virtual/postgresql-base )
	sqlite? ( >=dev-db/sqlite-3 )
	>=dev-libs/cxxtools-1.4.3"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

# Needed in this version (0.9.4) due to missing install-sh (and maybe others)
src_unpack() {
	unpack ${A}
	cd "${S}"

	AT_M4DIR="m4" eautoreconf
}

src_compile() {
	local myconf
	use doc || myconf="--without-doxygen"
	econf \
		${myconf} \
		$(use_with mysql) \
		$(use_with postgres postgresql) \
		$(use_with sqlite) \
		--docdir=/usr/share/doc/${PF} \
		--htmldir=/usr/share/doc/${PF}/html
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README NEWS doc/*.pdf

	insinto /usr/share/doc/${PF}/examples
	doins demo/*.{cpp,h}
}
