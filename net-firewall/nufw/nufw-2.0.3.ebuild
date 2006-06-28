# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="NuFW is an authenticating gateway"
HOMEPAGE="http://www.nufw.org/"
SRC_URI="http://www.nufw.org/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="prelude postgres mysql ldap gdbm pam"

DEPEND=">=dev-libs/glib-2
	net-firewall/iptables
	>=net-libs/gnutls-1.1
	>=dev-libs/cyrus-sasl-2
	mysql? ( dev-db/mysql )
	postgres? ( dev-db/postgresql )
	ldap? ( >=net-nds/openldap-2 )
	gdbm? ( sys-libs/gdbm )"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-configure.patch"
}

src_compile() {
	econf \
		$(use_with prelude prelude-log) \
		$(use_with postgres pgsql-log) \
		$(use_with mysql mysql-log) \
		$(use_with ldap) \
		$(use_with gdbm) \
		$(use_with pam system-auth) \
		--sysconfdir="/etc/nufw" \
		--localstatedir="/var" \
		--disable-debug \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	newinitd ${FILESDIR}/nufw-init.d nufw
	newconfd ${FILESDIR}/nufw-conf.d nufw
	newinitd ${FILESDIR}/nuauth-init.d nuauth
	newconfd ${FILESDIR}/nuauth-conf.d nuauth

	insinto /etc/nufw
	doins conf/nuauth.conf

	keepdir /var/run/nuauth

	dodoc AUTHORS ChangeLog INSTALL NEWS README TODO
	docinto doc
	dodoc doc/*
	docinto doc/modules
	dodoc doc/modules/*
	docinto scripts
	dodoc scripts/*
	docinto conf
	dodoc conf/*
}
