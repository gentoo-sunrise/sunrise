# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A mail storage and retrieval daemon that uses MySQL or PostgreSQL as its data store"
HOMEPAGE="http://www.dbmail.org/"
SRC_URI="http://www.dbmail.org/download/2.0/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="ssl postgres mysql"

DEPEND="
	ssl? ( dev-libs/openssl )
	mysql? ( >=dev-db/mysql-4.0.12 )
	postgres? ( dev-db/postgresql )
	sys-libs/zlib
"

pkg_setup() {
	if  use mysql && use postgres ; then
		eerror "Unfortunatly you can't have both MySQL and PostgreSQL"
		eerror " enabled at the same time."
		eerror "You have to remove either 'mysql' or 'postgres'"
		eerror "from your USE flags before emerging dbmail."
		exit 1
	fi

	if ! use mysql && ! use postgres ; then
		eerror "Unfortunatly you have to enable either MySQL or PostgreSQL"
		exit 1
	fi

	enewgroup dbmail
	enewuser dbmail -1 -1  /var/lib/dbmail dbmail
}

src_compile() {
	econf \
		$(use_with ssl) \
		$(use_with mysql) \
		$(use_with postgres) || die "econf failed"
	# --sysconfdir is not taken into consideration thus we use sed here
	sed -i -e "s:\(.*etc/\)\(.*$\):\1dbmail/\2:" dbmail.h
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR=${D} install || die "emake install failed"

	dodoc AUTHORS BUGS EXTRAS ChangeLog UPGRADING \
	INSTALL* VERSION NEWS README THANKS TODO
	dodoc sql/mysql/*
	dodoc sql/postgresql/*

	sed -i -e "s:nobody:dbmail:" dbmail.conf
	sed -i -e "s:nogroup:dbmail:" dbmail.conf
	insinto /etc/dbmail
	newins dbmail.conf dbmail.conf.dist

	newinitd ${FILESDIR}/dbmail-imapd.initd dbmail-imapd
	newinitd ${FILESDIR}/dbmail-lmtpd.initd dbmail-lmtpd
	newinitd ${FILESDIR}/dbmail-pop3d.initd dbmail-pop3d

	dobin contrib/mailbox2dbmail/mailbox2dbmail
	doman contrib/mailbox2dbmail/mailbox2dbmail.1

	keepdir /var/lib/dbmail
	fperms 750 /var/lib/dbmail

}

pkg_postinst() {
	einfo "Please read /usr/share/doc/${P}/INSTALL.gz"
	einfo "for remaining instructions on setting up dbmail users and "
	einfo "for finishing configuration to connect to your MTA and "
	einfo "to connect to your db."
	einfo "Database schemes can be found in /usr/share/doc/${P}/"
	einfo "You will also want to follow the installation instructions"
	einfo "on setting up the maintenance program to delete old messages."
	einfo "Don't forget to edit /etc/dbmail/dbmail.conf as well. :)"
	einfo ">>> --- For maintenance ---"
	einfo ">>> add this to crontab: 0 3 * * * /usr/bin/dbmail-util -cpdy >/dev/null 2>&1 "
}

