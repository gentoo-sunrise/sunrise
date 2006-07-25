# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

DESCRIPTION="A mail storage and retrieval daemon that uses MySQL or PostgreSQL as its data store"
HOMEPAGE="http://www.dbmail.org/"
SRC_URI="http://www.dbmail.org/download/2.1/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"
IUSE="ssl postgres"

DEPEND="ssl? ( dev-libs/openssl )
	postgres? ( >=dev-db/postgresql-7.4 )
	!postgres? ( >=dev-db/mysql-4.1.13 )
	app-text/asciidoc
	app-text/xmlto
	sys-libs/zlib
	>=dev-libs/gmime-2.1
	>=dev-libs/glib-2"

	# not yet implemented
	#depend dev-db/sqlite 

pkg_setup() {
	if use postgres && has_version dev-db/mysql ; then
		einfo "You have postgres use flag set, ${PN} will compile against PostgreSQL."
		einfo "If you want to use MySQL instead, unset postgres use flag for this ebuild:"
		einfo
		einfo "echo \"net-mail/dbmail -postgres\" >> /etc/portage/package.use"
		einfo
		epause 3
	fi

	enewgroup dbmail
	enewuser dbmail -1 -1  /var/lib/dbmail dbmail
}

src_compile() {
	eautoreconf
	econf \
		--sysconfdir=/etc/dbmail \
		$(use_with ssl) \
		$(use_with postgres) \
		$(use_with !postgres mysql) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS BUGS EXTRAS ChangeLog UPGRADING \
		INSTALL* VERSION NEWS README THANKS TODO
	dodoc sql/mysql/*
	dodoc sql/postgresql/*

	sed -i -e "s:nobody:dbmail:" dbmail.conf
	sed -i -e "s:nogroup:dbmail:" dbmail.conf
	insinto /etc/dbmail
	newins dbmail.conf dbmail.conf.dist

	newinitd "${FILESDIR}"/dbmail-imapd.initd dbmail-imapd
	newinitd "${FILESDIR}"/dbmail-lmtpd.initd dbmail-lmtpd
	newinitd "${FILESDIR}"/dbmail-pop3d.initd dbmail-pop3d

	dobin contrib/mailbox2dbmail/mailbox2dbmail
	doman contrib/mailbox2dbmail/mailbox2dbmail.1

	keepdir /var/lib/dbmail
	fperms 750 /var/lib/dbmail

}

pkg_postinst() {
	einfo "Please read /usr/share/doc/${PF}/INSTALL.gz"
	einfo "for remaining instructions on setting up dbmail users and "
	einfo "for finishing configuration to connect to your MTA and "
	einfo "to connect to your db."
	einfo
	einfo "Database schemes can be found in /usr/share/doc/${PF}/"
	einfo "You will also want to follow the installation instructions"
	einfo "on setting up the maintenance program to delete old messages."
	einfo "Don't forget to edit /etc/dbmail/dbmail.conf as well. :)"
	einfo ">>> --- For maintenance ---"
	einfo ">>> add this to crontab: 0 3 * * * /usr/bin/dbmail-util -cpdy >/dev/null 2>&1 "
}
