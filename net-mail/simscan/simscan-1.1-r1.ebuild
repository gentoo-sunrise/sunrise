# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Simscan is a simple program that enables qmail-smtpd to reject viruses, spam, and block attachments during the SMTP conversation"
HOMEPAGE="http://www.inter7.com/?page=simscan"
SRC_URI="http://www.inter7.com/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="clamav attachment custom-smtp-reject dropmsg regex quarantine per-domain
received spamassassin passthru"

DEPEND="
	clamav? ( app-antivirus/clamav )
	attachment? ( net-mail/ripmime )
	spamassassin? ( mail-filter/spamassassin )
	regex? ( dev-libs/libpcre )
"
RDEPEND="${DEPEND}
	virtual/qmail
"

RESTRICT="strip"

pkg_setup() {
	enewgroup clamav
	enewuser clamav -1 -1 /dev/null clamav
}

src_compile() {
	local myconf

	myconf="${myconf} --enable-user=clamav"

	if use clamav ; then
		myconf="${myconf} --enable-clamav=y"
	else
		myconf="${myconf} --enable-clamav=n"
	fi

	if use attachment ; then
		myconf="${myconf} --enable-attach=y"
		myconf="${myconf} --enable-ripmime=/usr/bin/ripmime"
	else
		myconf="${myconf} --enable-attach=n"
	fi

	if use custom-smtp-reject ; then
		myconf="${myconf} --enable-custom-smtp-reject=y"
	else
		myconf="${myconf} --enable-custom-smtp-reject=n"
	fi

	if use dropmsg ; then
		myconf="${myconf} --enable-dropmsg=y"
	else
		myconf="${myconf} --enable-dropmsg=n"
	fi

	if use regex ; then
		myconf="${myconf} --enable-regex=y"
		myconf="${myconf} --enable-pcre"
	else
		myconf="${myconf} --enable-regex=n"
	fi

	use quarantine && myconf="${myconf} --enable-quarantinedir"

	if use per-domain ; then
		myconf="${myconf} --enable-per-domain=y"
	else
		myconf="${myconf} --enable-per-domain=n"
	fi

	if use received ; then
		myconf="${myconf} --enable-received=y"
	else
		myconf="${myconf} --enable-received=n"
	fi

	if use spamassassin ; then
		myconf="${myconf} --enable-spam=y"
		if use passthru ; then
			myconf="${myconf} --enable-spam-passthru=y"
		else
			myconf="${myconf} --enable-spam-passthru=n"
		fi
	else
		myconf="${myconf} --enable-spam=n"
	fi

	econf ${myconf} || die "econf failed"
	emake simscan_LDFLAGS=-Wl,-z,now || die "emake failed"
}

src_install() {
	einfo "Installing documentation and contrib files"
	dodoc AUTHORS README TODO

	docinto contrib
	dodoc contrib/*.patch

	einfo "Installing binaries"
	exeinto /var/qmail/bin
	doexe simscan
	doexe simscanmk

	diropts -m750
	dodir /var/qmail/simscan
	fowners clamav:clamav /var/qmail/simscan /var/qmail/bin/simscan
	fperms 4711 /var/qmail/bin/simscan
	keepdir /var/qmail/simscan

	if use per-domain ; then
		einfo "Setting default configuration..."
		echo ':clam=yes,spam=yes' > simcontrol
		insopts -o root -g root -m 644
		insinto /var/qmail/control
		doins simcontrol
	fi
}

pkg_postinst() {
	einfo ""

	if use custom-smtp-reject ; then
		einfo "Becareful, if you use the \"custom-smtp-reject\" flag you will"
		einfo "have many problems if qmail was not patched with"
		einfo "qmail-queue-custom-error.patch"
		einfo ""
		ewarn "If your not sure, re-emerge simscan without this flag"
		einfo ""
	fi

	einfo "Now update the simscan configuration files :"
	ewarn "You have to do that after clamav or spamassassin update"
	einfo ""
	einfo "/var/qmail/bin/simscanmk"
	einfo "`/var/qmail/bin/simscanmk`"
	einfo ""
	einfo "/var/qmail/bin/simscanmk -g"
	einfo "`/var/qmail/bin/simscanmk -g`"
	einfo ""

	einfo "You must have qmail with QMAILQUEUE patch"
	einfo "And, in order use simscan, edit your tcp.qmail-smtpd rules"
	einfo "and update as follow (for example only)"
	einfo ""
	einfo ":allow,QMAILQUEUE=\"/var/qmail/bin/simscan\""
	einfo ""

	ewarn "Read the documentation and personnalize /var/qmail/control/simcontrol"
	einfo ""
}
