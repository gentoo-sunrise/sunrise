# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="MIMEDefang is a mail filtering framework for sendmail"
HOMEPAGE="http://www.mimedefang.org/"
SRC_URI="http://www.mimedefang.org/static/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
DEPEND=">=mail-mta/sendmail-8.13.5-r1
	>=dev-perl/IO-stringy-2.110
	>=perl-core/MIME-Base64-3.05
	>=dev-perl/MailTools-1.67
	>=dev-perl/MIME-tools-5.417
	>=dev-perl/Digest-SHA1-2.10
	>=perl-core/libnet-1.19
	>=dev-perl/Mail-Audit-2.1
	>=perl-core/Time-HiRes-1.82
	>=dev-perl/HTML-Tagset-3.10
	>=dev-perl/HTML-Parser-3.48
	>=dev-perl/Compress-Zlib-1.41
	>=dev-perl/Archive-Zip-1.16"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup defang
	enewuser defang -1 -1 /var/spool/MIMEDefang defang
	mkdir -p /var/spool/MIMEDefang
	chmod 775 /var/spool/MIMEDefang
	chown defang:defang /var/spool/MIMEDefang
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	rm -f ${D}/etc/mail/{mimedefang-filter,sa-mimedefang.cf}
	newinitd ${FILESDIR}/mimedefang-init mimedefang
	newconfd ${FILESDIR}/mimedefang-conf mimedefang
	insinto /etc/mail
	newins ${S}/examples/suggested-minimum-filter-for-windows-clients \
		mimedefang-filter.example
	[ -f /etc/mail/spamassassin/local.cf ] && \
		dosym /etc/mail/spamassassin/local.cf /etc/mail/sa-mimedefang.cf
	dodoc Changelog README README.ANOMY README.IRIX README.NONROOT \
		README.SECURITY README.SOPHIE README.SPAMASSASSIN 
	keepdir /var/spool/{MIMEDefang,MD-Quarantine}
	fperms 755 /var/spool/MD-Quarantine
	fowners defang:defang /var/spool/MD-Quarantine
}
