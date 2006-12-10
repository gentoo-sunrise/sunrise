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
IUSE="attachment clamav custom-smtp-reject dropmsg passthru per-domain quarantine received regex spamassassin"

DEPEND="clamav? ( app-antivirus/clamav )
	attachment? ( net-mail/ripmime )
	spamassassin? ( mail-filter/spamassassin )
	regex? ( dev-libs/libpcre )"
RDEPEND="${DEPEND}
	virtual/qmail"

pkg_setup() {
	enewgroup clamav
	enewuser clamav -1 -1 /dev/null clamav
}

src_compile() {
	local myconf

	myconf="${myconf} --enable-user=clamav"

	for flag in clamav custom-smtp-reject dropmsg per-domain received ; do
		if use ${flag} ; then
			myconf="${myconf} --enable-${flag}=y"
		else
			myconf="${myconf} --enable-${flag}=n"
		fi
	done

	if use attachment ; then
		myconf="${myconf} --enable-attach=y"
		myconf="${myconf} --enable-ripmime=/usr/bin/ripmime"
	else
		myconf="${myconf} --enable-attach=n"
	fi

	if use regex ; then
		myconf="${myconf} --enable-regex=y"
		myconf="${myconf} --enable-pcre"
	else
		myconf="${myconf} --enable-regex=n"
	fi

	use quarantine && myconf="${myconf} --enable-quarantinedir"

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
		ewarn "Be careful, if you use the \"custom-smtp-reject\" flag you will"
		ewarn "have many problems if qmail was not patched with"
		ewarn "qmail-queue-custom-error.patch"
		ewarn
		ewarn "If your not sure, re-emerge simscan without this flag"
		ewarn
	fi

	elog "Now update the simscan configuration files :"
	elog "You have to do that after clamav or spamassassin update"
	elog
	elog "/var/qmail/bin/simscanmk"
	elog "`/var/qmail/bin/simscanmk`"
	elog ""
	elog "/var/qmail/bin/simscanmk -g"
	elog "`/var/qmail/bin/simscanmk -g`"
	elog ""

	elog "You must have qmail with QMAILQUEUE patch"
	elog "And, in order use simscan, edit your tcp.qmail-smtpd rules"
	elog "and update as follow (for example only)"
	elog
	elog ":allow,QMAILQUEUE=\"/var/qmail/bin/simscan\""
	elog

	elog "Read the documentation and personalize /var/qmail/control/simcontrol"
	elog ""
}
