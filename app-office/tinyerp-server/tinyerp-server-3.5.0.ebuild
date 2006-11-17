# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils distutils

DESCRIPTION="Open Source ERP & CRM"
HOMEPAGE="http://tinyerp.org/"
SRC_URI="${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RESTRICT="fetch"

DEPEND=">=dev-db/postgresql-7.4
	dev-python/pypgsql
	dev-python/reportlab
	dev-python/pyparsing
	media-gfx/pydot
	=dev-python/psycopg-1*
	dev-libs/libxml2
	dev-libs/libxslt"
RDEPEND=${DEPEND}

TINYERP_USER=terp
TINYERP_GROUP=terp
TINYERP_DATABASE=terp

DOWNLOAD_URL="http://tinyerp.com/component/option,com_vfm/Itemid,61/do,download/file,stable|source|${P}.tar.gz/"
pkg_nofetch() {
	einfo "Please donwload ${SRC_URI} from:"
	einfo ${DOWNLOAD_URL}
	einfo "and move it to ${DISTDIR}"
}

pkg_setup() {
	if ! built_with_use dev-libs/libxslt python ; then
		eerror "dev-libs/libxslt must be built with python"
		die "${PN} requires dev-libs/libxslt with USE=python"
	fi
}
src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-setup.patch"
}

src_install() {
	distutils_src_install

	newinitd "${FILESDIR}"/tinyerp-init.d tinyerp
	newconfd "${FILESDIR}"/tinyerp-conf.d tinyerp

	keepdir /var/run/tinyerp
	keepdir /var/log/tinyerp
}

pkg_postinst() {
	enewgroup ${TINYERP_GROUP}
	enewuser ${TINYERP_USER} -1 -1 -1 ${TINYERP_GROUP}

	fowners ${TINYERP_USER}:${TINYERP_GROUP} /var/run/tinyerp
	fowners ${TINYERP_USER}:${TINYERP_GROUP} /var/log/tinyerp

	elog "In order to setup the initial database, run:"
	elog "  emerge --config =${CATEGORY}/${PF}"
	elog "Be sure the database is started before"
}

pquery() {
	psql -q -At -U postgres -d template1 -c "$@"
}

pkg_config() {
	einfo "In the following, the 'postgres' user will be used."
	if ! pquery "SELECT usename FROM pg_user WHERE usename = '${TINYERP_USER}'" | grep -q ${TINYERP_USER}; then
		ebegin "Creating database user ${TINYERP_USER}"
		createuser --quiet --username=postgres --no-createdb --no-adduser --no-createrole ${TINYERP_USER}
		eend $? || die "Failed to create database user"
	fi

	if ! pquery "SELECT datname FROM pg_database WHERE datname = '${TINYERP_DATABASE}'" |grep -q terp; then
		ebegin "Creating database ${TINYERP_DATABASE}"
		createdb --quiet --username=postgres --owner=terp --encoding=UNICODE ${TINYERP_DATABASE}
		eend $? || die "Failed to create database"
	fi

	einfo "The first time tinyerp-server is run it will initialize the database"
}
