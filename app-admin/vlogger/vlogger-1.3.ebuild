# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Virtual web logfile rotater/parser, similar to cronolog and httplog"
HOMEPAGE="http://n0rp.chemlab.org/vlogger/"
SRC_URI="http://n0rp.chemlab.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbi"

DEPEND=""
RDEPEND="dev-perl/TimeDate
	dbi? ( dev-perl/DBI )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -e 's:/usr/local/sbin/vlogger:/usr/sbin/vlogger:' -i vlogger vlogger.1
}

src_install() {
	doman vlogger.1
	dodoc README
	insinto /etc/vlogger
	dosbin vlogger
	if use dbi ; then
		doins vlogger-dbi.conf
		dodoc mysql_create.sql
	fi
}

pkg_postinst() {
	if use dbi ; then
		elog "If you wish to use vlogger with DBI please see /etc/vlogger/vlogger-dbi.conf"
		elog "The SQL to create the tables for DBI can be found in /usr/share/doc/${P}"
	fi
}
