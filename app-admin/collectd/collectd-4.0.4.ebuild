# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A small daemon to collect system statistics into RRD files."
HOMEPAGE="http://collectd.org/"
SRC_URI="http://collectd.org/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lm_sensors hddtemp mysql perl"

DEPEND="net-misc/curl
	>=net-analyzer/rrdtool-1.2
	hddtemp? ( app-admin/hddtemp )
	lm_sensors? ( >=sys-apps/lm_sensors-2.9.0 )
	mysql? ( >=dev-db/mysql-4.1 )"

src_compile() {
	econf $(use_enable lm_sensors sensors) $(use_enable mysql) \
		$(use_enable perl)
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"

	dodoc AUTHORS ChangeLog README NEWS TODO

	docinto contrib
	dodoc contrib/*

	keepdir /var/lib/collectd

	newinitd "${FILESDIR}/${P}.initd" collectd
	newconfd "${FILESDIR}/${P}.confd" collectd

	insinto /etc
	newins "${FILESDIR}/${P}.conf" collectd.conf
}

pkg_postinst() {
	einfo "collectd introduced some changes in the new 4.x series."
	einfo "For further information, read http://collectd.org/migrate-v3-v4.shtml"
	einfo "The migration script can be found at:"
	einfo "/usr/share/doc/${P}/contrib/migrate-3-4.px.bz2"
}
