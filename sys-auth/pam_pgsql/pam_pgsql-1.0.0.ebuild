# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit pam

DESCRIPTION="pam_pgsql is a module for pam to authenticate users with PostgreSQL"
HOMEPAGE="http://pgfoundry.org/frs/?group_id=1000039"
SRC_URI="mirror://postgresql/projects/pgFoundry/sysauth/${PN/_/-}-${PV}.tgz"
RESTRICT="mirror"

DEPEND=">=sys-libs/pam-0.78-r3
	>=app-crypt/mhash-0.9.1
	>=dev-db/postgresql-7.3.6"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

S="${WORKDIR}/${PN/_/-}"

src_unpack() {
	unpack ${A} || die "unpack failed"
}

src_compile() {
	econf || die "econf failed"
	emake CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	insinto /etc
	newins "${FILESDIR}/pam_pgsql.conf" pam_pgsql.conf
	dopammod pam_pgsql.so
	dodoc debian/changelog README CREDITS
}

pkg_postinst() {
	einfo "From version 0.6 you can also use new style configuration (overrides"
	einfo "legacy values). See /usr/share/doc/${P}/README for more info."
}
