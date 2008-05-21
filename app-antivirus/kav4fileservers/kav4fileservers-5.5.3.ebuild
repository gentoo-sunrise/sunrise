# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P="kav4fileservers-linux-${PV}"
S="${WORKDIR}/kav4fileservers-linux-install"

DESCRIPTION="Kaspersky File Server virus scanner"
HOMEPAGE="http://www.kaspersky.com/"
SRC_URI="ftp://ftp.kaspersky.com/products/release/english/businessoptimal/file_servers/kavlinuxserver/${MY_P}.tar.gz"

SLOT="0"
LICENSE="KASPERSKY"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND="virtual/cron"
PROVIDE="virtual/antivirus"
RESTRICT="mirror strip"

pkg_setup() {
	enewgroup klusers
	enewuser kluser -1 -1 /var/db/kav klusers
}

src_install() {
	dodir /var/log/kav/5.5/kav4unix
	dodir /var/db/kav/5.5/kav4unix/{bases,bases.backup,licenses,patches}
	fowners kluser:klusers /var/log/kav/5.5/kav4unix
	fowners kluser:klusers /var/db/kav/5.5/kav4unix/licenses
	fperms 0770 /var/log/kav/5.5/kav4unix
	fperms 0770 /var/db/kav/5.5/kav4unix/licenses

	insinto /var/db/kav/5.5/kav4unix/bases
	doins bases/*

	into /opt/kav/5.5/kav4unix
	dobin bin/*

	insinto /opt/kav/5.5/kav4unix/contrib
	insopts -m0755
	doins contrib/*.sh
	insopts -m0644
	doins contrib/*.wbm

	insinto /etc/kav/5.5/kav4unix
	doins kav4unix/kav4unix.conf

	# TODO: provide a gentooified initscript
	doinitd "${S}/init.d/kavmonitor"

	dodoc kav4unix/ChangeLog
	doman man8/*.8
}

pkg_postinst() {
	ewarn "IMPORTANT!!! You must install a valid Kaspersky Lab license file"
	ewarn "to use the application. Licenses should be installed into"
	ewarn "/var/db/kav/5.5/kav4unix/licenses. To do this, run:"
	ewarn
	ewarn "    /opt/kav/5.5/kav4unix/bin/licensemanager -a <keyfile> "
	ewarn
	ewarn "You need to download the latest anti-virus bases before using"
	ewarn "this application. To do this, run:"
	ewarn
	ewarn "    /opt/kav/5.5/kav4unix/bin/keepup2date"

	elog
	elog " To keep anti-virus bases up-to-date, create a cron job for KAV:"
	elog
	elog " crontab -u kluser -e"
	elog
	elog " and add the following line (change the frequency of update if required):"
	elog
	elog " * */4 * * *     /opt/kav/5.5/kav4unix/bin/keepup2date >/dev/null 2>&1"
	elog
	elog "Configuration file was installed in /etc/kav/5.5/kav4unix/kav4unix.conf."
	elog "See \"man 8 kav4unix.conf\" for detailed configuration info."
	elog
	elog "If you want to use web interface to configure and use Kaspersky Anti-Virus"
	elog "emerge app-admin/webmin and then install the module via webmin interface."
	elog "Webmin module is located in /opt/kav/5.5/kav4unix/contrib/kavfs.wbm"
}
