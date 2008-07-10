# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit pam

DESCRIPTION="pam_pgsql is a module for pam to authenticate users with PostgreSQL"
HOMEPAGE="http://pgfoundry.org/frs/?group_id=1000039"
SRC_URI="mirror://postgresql/projects/pgFoundry/sysauth/${PN/_/-}-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=">=sys-libs/pam-0.78-r3
	>=app-crypt/mhash-0.9.1
	>=dev-db/postgresql-7.3.6"

S="${WORKDIR}/${PN/_/-}"

src_install() {
	insinto /etc
	newins "${FILESDIR}/pam_pgsql.conf" pam_pgsql.conf
	dopammod pam_pgsql.so
	dodoc debian/changelog README CREDITS
}

pkg_postinst() {
	elog "From version 0.6 you can also use new style configuration (overrides"
	elog "legacy values). See /usr/share/doc/${PF}/README for more info."
}
