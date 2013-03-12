# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit user scons-utils

DESCRIPTION="The eXtensible Open Router Platform"
HOMEPAGE="http://www.xorp.org/"
SRC_URI="http://www.xorp.org/releases/current/${P}-src.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="snmp"

DEPEND=">=dev-lang/python-2.0
	dev-libs/openssl
	sys-libs/ncurses
	snmp? ( net-analyzer/net-snmp )"
RDEPEND="${DEPEND}
	net-analyzer/traceroute"

S="${WORKDIR}/${PN}"

pkg_setup() {
	enewgroup xorp
}

src_configure() {
	myesconsargs=(
		$(use_scons snmp ENABLE_SNMP)
		)
}

src_compile() {
	escons
}

src_install() {
	escons DESTDIR="${D}" install || die "emake install failed"

	newconfd "${FILESDIR}/xorp-confd" xorp
	newinitd "${FILESDIR}/xorp-initd" xorp

	dodoc BUGS ERRATA RELEASE_NOTES VERSION
}

pkg_postinst() {
	elog "Only users who belong to the xorp group"
	elog "can run xorpsh in configurational mode."
	elog "You must create /etc/xorp/config.boot,"
	elog "you can use the sample /etc/xorp/config.boot.dist"
}
