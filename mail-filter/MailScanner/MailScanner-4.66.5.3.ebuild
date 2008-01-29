# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

MY_PV=$(get_version_component_range 1-3 )
MY_PVR=$(replace_version_separator 3 '-' )

DESCRIPTION="Free Anti-Virus and Anti-Spam Filter"
HOMEPAGE="http://www.mailscanner.info/"
SRC_URI="http://www.mailscanner.info/files/4/tar/${PN}-install-${MY_PVR}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="bitdefender clamav doc exim f-prot postfix spamassassin"

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}
	dev-perl/Archive-Zip
	dev-perl/Compress-Zlib
	dev-perl/Convert-BinHex
	dev-perl/Convert-TNEF
	dev-perl/DBD-SQLite
	dev-perl/DBI
	>=dev-perl/HTML-Parser-3.45
	dev-perl/HTML-Tagset
	dev-perl/IO-stringy
	>=dev-perl/MIME-tools-5.417
	dev-perl/MailTools
	dev-perl/Net-CIDR
	dev-perl/Net-DNS
	dev-perl/TimeDate
	dev-perl/Sys-Hostname-Long
	>=net-mail/tnef-1.4.3
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	virtual/perl-Getopt-Long
	>=virtual/perl-Sys-Syslog-0.18
	>=virtual/perl-MIME-Base64-3.05
	virtual/cron
	postfix? ( mail-mta/postfix )
	exim? ( !postfix? ( mail-mta/exim ) )
	!postfix? ( !exim? ( mail-mta/sendmail ) )
	bitdefender? ( app-antivirus/bitdefender-console )
	clamav? ( >=app-antivirus/clamav-0.88.4 )
	f-prot? ( app-antivirus/f-prot )
	spamassassin? ( >=mail-filter/spamassassin-3.1.5 )"

S="${WORKDIR}/${PN}-${MY_PVR}"
BASE="/usr"

src_unpack() {
	unpack ${A}
	unpack ./${PN}-install-${MY_PV}/perl-tar/${PN}-${MY_PVR}.tar.gz

	# setup MTA
	if use postfix ; then
		RUNASUSER='postfix'
		RUNASGROUP='postfix'
		INQUEUE='/var/spool/postfix.in/deferred'
		OUTQUEUE='/var/spool/postfix/incoming'
		MTA='postfix'
		SENDMAIL='/usr/lib/sendmail'
		SENDMAIL2='/usr/lib/sendmail'
	elif use exim ; then
		RUNASUSER='mail'
		RUNASGROUP='mail'
		INQUEUE='/var/spool/exim.in/input'
		OUTQUEUE='/var/spool/exim/input'
		MTA='exim'
		SENDMAIL='/usr/sbin/exim -oMr MailScanner'
		SENDMAIL2='/usr/sbin/exim -C /etc/exim/exim_out.conf -oMr MailScanner'
	else
	#	use sendmail as default, but we should add more as needed
	#	RUNASUSER='mail'
	#	RUNASGROUP='mail'
		INQUEUE='/var/spool/mqueue.in'
		OUTQUEUE='/var/spool/mqueue'
		MTA='sendmail'
		SENDMAIL='/usr/lib/sendmail'
		SENDMAIL2='/usr/lib/sendmail'
	fi

	# update init script parameters for selected MTA
	sed \
	-e "s|^\(MTA=\).*|\1${MTA}|g" \
		"${FILESDIR}/confd.mailscanner-mta" > "${S}/confd.mailscanner-mta"

	# setup virus scanner(s)
	VIRUS_SCANNERS=""
	use bitdefender && VIRUS_SCANNERS="bitdefender ${VIRUS_SCANNERS}"
	use clamav && VIRUS_SCANNERS="clamav ${VIRUS_SCANNERS}"
	use f-prot && VIRUS_SCANNERS="f-prot ${VIRUS_SCANNERS}"

	if [ "$VIRUS_SCANNERS" == "" ]; then
		VIRUS_SCANNERS="none"
		VIRUS_SCANNING="no"
	else
		VIRUS_SCANNING="yes"
	fi

	sed -i \
		-e "s/^\(Virus Scanning[ \t]*=\).*/\1 ${VIRUS_SCANNING}/" \
		-e "s/^\(Virus Scanners[ \t]*=\).*/\1 ${VIRUS_SCANNERS}/" \
		"${S}/etc/MailScanner.conf"

	# setup spamassassin
	if use spamassassin ; then
		sed -i \
			-e "s/^\(Use SpamAssassin[ \t]*=\).*$/\1 yes/" \
			"${S}/etc/MailScanner.conf"
	else
		sed -i \
			-e "s/^\(Use SpamAssassin[ \t]*=\).*$/\1 no/" \
			"${S}/etc/MailScanner.conf"
	fi

	# update bin files
	sed -i \
		-e "s#msbindir=/opt/MailScanner/bin#msbindir=/usr/sbin#g" \
		-e "s#config=/opt/MailScanner/etc/MailScanner.conf#config=/etc/MailScanner/MailScanner.conf#g" \
		"${S}/bin/check_mailscanner"
	sed -i \
		-e "s#/opt/MailScanner/etc#/etc/MailScanner#g" \
		"${S}/bin/update_virus_scanners"
	sed -i \
		-e "s#/opt/MailScanner/etc#/etc/MailScanner#g" \
		-e "s#/opt/MailScanner/lib#/usr/lib/MailScanner#g" \
		"${S}/bin/MailScanner"

	# update cron files
	sed -i \
		-e "s#/opt/MailScanner/bin/check_mailscanner#/usr/sbin/check_MailScanner#g" \
		"${S}/bin/cron/check_MailScanner.cron"
	for cronfile in update_virus_scanners.cron update_{,bad_}phishing_sites.cron; do
	sed -i \
		-e "s#/etc/sysconfig/MailScanner#/etc/conf.d/mailscanner#g" \
		-e "s#/opt/MailScanner/bin#/usr/sbin#g" \
		"${S}/bin/cron/${cronfile}"
	done

	# Determine some things that may need to be changed in conf file
	# (need to arrive at sensible replacement for yoursite)
	YOURSITE=`dnsdomainname | sed -e "s/\./-/g"`
	BASEBIN="${BASE}/sbin"

	# ClamAV requires some specific changes to MailScanner.conf
	# when mailscanner is running as root (i.e. sendmail)
	if use clamav ; then
		if [ "$MTA" == "sendmail" ] ; then
			WORKGRP="clamav"
			WORKPERM="0640"
		else
			WORKGRP=""
			WORKPERM="0600"
		fi
	else
		WORKGRP=""
		WORKPERM="0600"
	fi

	# update conf files
	sed -i \
		-e "s#/opt/MailScanner/etc#/etc/MailScanner#g" \
		-e "s#/opt/MailScanner/bin#$BASEBIN#g" \
		-e "s#/opt/MailScanner/lib#/usr/lib/MailScanner#g" \
		-e "s#^\(Run As User[ \t]*=\).*#\1 $RUNASUSER#" \
		-e "s#^\(Run As Group[ \t]*=\).*#\1 $RUNASGROUP#" \
		-e "s#^\(Incoming Queue Dir[ \t]*=\).*#\1 $INQUEUE#" \
		-e "s#^\(Outgoing Queue Dir[ \t]*=\).*#\1 $OUTQUEUE#" \
		-e "s#^\(MTA[ \t]*=\).*#\1 $MTA#" \
		-e "s/^#\(TNEF.*internal\)$/\1/" \
		-e "s/^\(TNEF.*0000\)$/#\1/" \
		-e "s#^\(PID file[ \t]=\).*#\1 /var/run/mailscanner.pid#" \
		-e "s#^\(%org-name%\)[ \t]*=.*#\1 = ${YOURSITE}#" \
		-e "s#^\(Sendmail[ \t]*=\).*#\1 ${SENDMAIL}#" \
		-e "s#^\(Sendmail2[ \t]*=\).*#\1 ${SENDMAIL2}#" \
		-e "s#^\(Incoming Work Group[ \t]*=\).*#\1 ${WORKGRP}#" \
		-e "s#^\(Incoming Work Permissions[ \t]*=\).*#\1 ${WORKPERM}#" \
		"${S}/etc/MailScanner.conf"

	# net-mail/clamav net-mail/f-prot package compatibility
	sed -i \
		-e "s#/opt/MailScanner/lib#/usr/lib/MailScanner#" \
		-e 's#^\(clamav\t.*/usr\)/local$#\1#' \
		-e 's#^\(f-prot.*\)/usr/local/f-prot$#\1/opt/f-prot#' \
		"${S}/etc/virus.scanners.conf"

	# update lib files
	sed -i \
		-e "s#/opt/MailScanner/bin#$BASEBIN#g" \
		-e "s#/opt/MailScanner/etc#/etc/MailScanner#g" \
		-e "s#/opt/MailScanner/lib#/usr/lib/MailScanner#g" \
		"${S}/lib/MailScanner/ConfigDefs.pl"
	sed -i \
		-e "s#/etc/MailScanner#/etc/MailScanner#g" \
		"${S}/lib/MailScanner/CustomConfig.pm"

	# finally, change MailScanner.conf into MailScanner.conf.sample
	cp "${S}/etc/MailScanner.conf" "${S}/etc/MailScanner.conf.${MY_PV}"
	mv "${S}/etc/MailScanner.conf" "${S}/etc/MailScanner.conf.sample"

}

src_install() {
	exeinto ${BASE}/sbin
	doexe	bin/MailScanner
	newexe	bin/check_mailscanner check_MailScanner
	doexe	bin/d2mbox bin/df2mbox
	doexe	bin/update_virus_scanners
	doexe	bin/upgrade_MailScanner_conf
	doexe   bin/update_bad_phishing_sites bin/update_phishing_sites
	newexe	bin/Sophos.install.linux Sophos.install

	insinto	/etc/MailScanner
	doins	etc/*.conf
	doins	etc/mailscanner.conf.with.mcp
	doins	etc/MailScanner.conf.${MY_PV}
	doins	etc/MailScanner.conf.sample

	insinto	/etc/MailScanner/rules
	doins	etc/rules/*
	insinto	/etc/MailScanner/mcp
	doins	etc/mcp/*

	insinto /etc/MailScanner
	doins -r etc/reports

	insinto	${BASE}/$(get_libdir)/MailScanner
	doins	lib/*.prf

	exeinto ${BASE}/$(get_libdir)/MailScanner
	doexe	lib/*-wrapper
	doexe	lib/*-autoupdate
	doexe	lib/*-autoupdate.old
	doexe	lib/*.pm

	exeinto	${BASE}/$(get_libdir)/MailScanner/MailScanner
	doexe	lib/MailScanner/*.pm
	doexe	lib/MailScanner/*.pl

	insinto	${BASE}/$(get_libdir)/MailScanner/MailScanner
	doins	lib/MailScanner/*.txt

	exeinto	${BASE}/$(get_libdir)/MailScanner/MailScanner/CustomFunctions
	doexe	lib/MailScanner/CustomFunctions/MyExample.pm

	newinitd "${FILESDIR}"/initd.mailscanner MailScanner
	newinitd "${FILESDIR}"/initd.mailscanner-mta MailScanner-mta
	newconfd "${FILESDIR}"/confd.mailscanner MailScanner
	newconfd "${S}"/confd.mailscanner-mta MailScanner-mta

	#Set up cron jobs
	exeinto /etc/cron.hourly
	newexe "${S}/bin/cron/check_MailScanner.cron" check_MailScanner
	for cronfile in update_{virus_scanners,{bad_,}phishing_sites}; do
		newexe "${S}/bin/cron/${cronfile}.cron" ${cronfile}
	done

	exeinto /etc/cron.daily
	newexe "${S}/bin/cron/clean.quarantine.cron" clean.quarantine

	dodoc README
	insinto /usr/share/doc/${PF}
	doins MailScanner.conf.index.html

	keepdir /var/spool/MailScanner/incoming
	keepdir /var/spool/MailScanner/quarantine
	keepdir /var/spool/MailScanner/spamassassin
	keepdir /var/spool/MailScanner/archive
	keepdir ${BASE}/var

	if use postfix ; then
		chown -R postfix:postfix "${D}/var/spool/MailScanner/"
	elif use exim ; then
		chown -R mail:mail "${D}/var/spool/MailScanner/"
	else
		keepdir /var/spool/mqueue.in
	fi
}

pkg_postinst() {
	if [ -n "`grep -xE "[[:space:]]*provide[[:space:]]+(.*[[:space:]]+)*mta([[:space:]]+.*)*" /etc/init.d/${MTA}`" ]; then
		ewarn
		ewarn "Warning: your mta service startup script /etc/init.d/${MTA}"
		ewarn "seems to provide 'mta', this may give problems with /etc/init.d/MailScanner-mta."
		ewarn
		ewarn "The Installation is *NOT* Completed Yet, You still need Filesystem::Df"
		ewarn "Please use emerge g-cpan and run the following command"
		ewarn
		ewarn " # g-cpan -i Filesys::Df "
		ewarn

		echo
	fi

	if [ -f "/etc/MailScanner/MailScanner.conf" ]; then
		einfo "Upgrading the MailScanner.conf file"
		cp /etc/MailScanner/MailScanner.conf /etc/MailScanner/MailScanner.conf.pre_upgrade.${MY_PV}
		/usr/sbin/upgrade_MailScanner_conf \
		/etc/MailScanner/MailScanner.conf.pre_upgrade.${MY_PV} \
		/etc/MailScanner/MailScanner.conf.${MY_PV} \
		> /etc/MailScanner/MailScanner.conf 2> /dev/null
	else
		cp /etc/MailScanner/MailScanner.conf.sample /etc/MailScanner/MailScanner.conf
	fi
}
