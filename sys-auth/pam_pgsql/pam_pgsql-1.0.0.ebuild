# Copyright 1999-2010 Gentoo Foundation
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
	dev-db/postgresql-base"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN/_/-}"

src_install() {
	insinto /etc
	newins "${FILESDIR}/pam_pgsql.conf" pam_pgsql.conf || die "newins failed"
	dopammod pam_pgsql.so
	dodoc debian/changelog CREDITS README || die "dodoc failed"
}

pkg_postinst() {
	einfo "From version 0.6 you can also use new style configuration (overrides"
	einfo "legacy values). See /usr/share/doc/${PF}/README for more info."
}
