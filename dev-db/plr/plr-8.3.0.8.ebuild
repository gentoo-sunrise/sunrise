# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib

DESCRIPTION="R language addon for postgresql database"
HOMEPAGE="http://www.joeconway.com/plr/"
SRC_URI="http://www.joeconway.com/plr/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="8.3"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/R
	=virtual/postgresql-server-${SLOT}*"
DEPEND="${RDEPEND}"

S="${WORKDIR}/contrib/${PN}"

src_unpack() {
	unpack ${A}
	# the build system wants 'contrib' to be part of the path
	mkdir "${WORKDIR}/contrib"
	mv "${WORKDIR}/${PN}" "${S}"
}

src_compile() {
	if has_version "dev-db/postgresql-server:${SLOT}" ; then
		export PG_CONFIG="/usr/$(get_libdir)/postgresql-${SLOT}/bin/pg_config"
	fi
	USE_PGXS=1 emake -j1 || die "emake failed"
}

src_install() {
	USE_PGXS=1 emake -j1 DESTDIR="${D}" install || die "emake install failed"
}

pkg_postinst() {
	local sharepath
	if has_version "dev-db/postgresql-server:${SLOT}" ; then
		sharepath="/usr/share/postgresql-${SLOT}/contrib"
	else
		sharepath="/usr/share/postgresql/contrib"
	fi
	einfo
	einfo "To install PL/R to your database issue"
	einfo
	einfo "\t psql -d mydatabase -U pg_username < ${sharepath}/plr.sql"
	einfo
	einfo "You may have to login as database administrator."
	einfo
	einfo "You have to define PL/R as TRUSTED language to allow non-administrators"
	einfo "to use it. Change the CREATE LANGUAGE statement in the plr.sql file"
	einfo "into"
	einfo
	einfo "\t CREATE TRUSTED LANGUAGE plr HANDLER plr_call_handler;"
	einfo
	einfo "update the database as shown above and allow a specific user to"
	einfo "use PL/R by"
	einfo
	einfo "\t GRANT USAGE ON LANGUAGE plr TO pg_username;"
	einfo
	einfo "For further information on PL/R have a look at"
	einfo
	einfo "\t http://www.joeconway.com/plr/"
	einfo
}
