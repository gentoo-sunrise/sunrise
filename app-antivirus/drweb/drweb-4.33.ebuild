# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P="drweb-${PV}"
S="${WORKDIR}/${P}-glibc2.3"

DESCRIPTION="DrWeb virus scaner for Linux"
HOMEPAGE="http://www.drweb.com"
SRC_URI="http://download.drweb.com/files/unix/Linux/Generic/${MY_P}-glibc2.3.tar.gz
	doc? ( linguas_ru? ( ftp://ftp.drweb.com/pub/drweb/unix/doc/${PN}-${PV/./}-unix-ru-pdf.zip ) )
	doc? ( ftp://ftp.drweb.com/pub/drweb/unix/doc/${PN}-${PV/./}-unix-en-pdf.zip )"
RESTRICT="mirror strip"

SLOT="0"
LICENSE="DRWEB"
KEYWORDS="~x86"
IUSE="doc linguas_ru logrotate"

DEPEND="app-arch/unzip"
RDEPEND="${DEPEND}
	dev-perl/libwww-perl
	virtual/cron
	logrotate? ( app-admin/logrotate )"

PROVIDE="virtual/antivirus"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PF}-gentoo.patch" || die "epatch failed"
}

pkg_setup() {
	# Create drweb user/group
	enewgroup drweb
	enewuser drweb -1 -1 /var/drweb drweb
}

src_compile() {
	einfo "Nothing to compile, installing DrWeb..."
}

src_install() {
	cp -pPR ${S}/opt/ ${D}/opt
	cp -pPR ${S}/var/ ${D}/var
	cp -pPR ${S}/etc/ ${D}/etc

	# Create log dir in proper location
	rm -rf ${D}/var/drweb/log/
	rm -rf ${D}/var/drweb/spool/
	dodir /var/log/drweb
	dodir /var/spool/drweb

	# Set up permissions
	fowners drweb:drweb /opt/drweb/lib
	fowners drweb:drweb /var/drweb/{bases,infected,run,updates}
	fowners drweb:drweb /etc/drweb/email.ini
	fowners drweb:drweb /var/log/drweb
	fowners drweb:drweb /var/spool/drweb
	fperms 0640 /etc/drweb/email.ini
	fperms 0750 /var/drweb/infected
	fperms 0700 /var/drweb/run
	fperms 0700 /var/drweb/updates
	fperms 0770 /var/spool/drweb
	chown -R drweb:drweb ${D}/var/drweb/bases
	chown -R drweb:drweb ${D}/opt/drweb/lib

	if use logrotate ; then
		insinto /etc/logrotate.d
		newins ${D}/etc/drweb/drweb-log drweb
	fi
	rm -f ${D}/etc/drweb/drweb-log

	newinitd ${D}/etc/init.d/drwebd drweb
	rm -f ${D}/etc/init.d/drwebd

	local docdir="${D}/opt/drweb/doc"
	for doc in ${docdir}/{ChangeLog,FAQ,readme.eicar,readme.license} \
		    ${docdir}/daemon/readme.daemon \
		    ${docdir}/scanner/readme.scanner \
		    ${docdir}/update/readme.update ; do
		dodoc ${doc} && rm -f ${doc}
	done
	dodoc ${D}/opt/drweb/getkey.HOWTO

	if use linguas_ru ; then
		    for doc_ru in ${docdir}/{ChangeLog.rus,FAQ.rus,readme.eicar.rus,readme.license.rus} \
			${docdir}/daemon/readme.daemon.rus \
			${docdir}/scanner/readme.scanner.rus \
			${docdir}/update/readme.update.rus ; do
		dodoc ${doc_ru} && rm -f ${doc_ru}
		done
		dodoc ${D}/opt/drweb/getkey.rus.HOWTO
	fi

	rm -rf ${docdir} && rm -f ${D}/opt/drweb/getkey.*

	use doc && dodoc ${WORKDIR}/drwunxen.pdf
	use doc && use linguas_ru && dodoc ${WORKDIR}/drwunxru.pdf
}

pkg_postinst() {
	einfo
	einfo " Create a cron entry for DrWeb auto updates in a similar manner:"
	einfo
	einfo " crontab -u drweb -e"
	einfo
	einfo " and add the following line (change the frequency of update if required):"
	einfo
	einfo " * */4 * * *     if [ -x /opt/drweb/update/update.pl ]; then /opt/drweb/update/update.pl; fi"
	einfo

	einfo
	einfo "To configure DrWeb, edit /etc/drweb/drweb32.ini as needed."
	einfo

	if use logrotate ; then
		einfo "DrWeb logrotate script has been provided."
		einfo "Edit /etc/logrotate.d/drweb as needed."
	fi

	ewarn
	ewarn "IMPORTANT!!!"
	ewarn
	ewarn "If you don't have a license for DrWeb, go to http://download.drweb.com/demo/ "
	ewarn "to obtain a demo licence."
	ewarn
	ewarn "Additional information can be obtained from /usr/share/doc/${PF}/readme.license"
}
