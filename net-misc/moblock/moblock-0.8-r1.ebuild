# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs linux-info

KEYWORDS="~amd64 ~x86"

MY_P=${P/mob/MoB}

DESCRIPTION="Blocks connections from/to hosts listed in a file in peerguardian format using iptables."
HOMEPAGE="http://moblock.berlios.de/"
SRC_URI="mirror://berlios/${PN}/${MY_P}-i586.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=">=net-libs/libnetfilter_queue-0.0.11
		>=net-libs/libnfnetlink-0.0.14
		net-firewall/iptables"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

CONFIG_CHECK="NETFILTER NETFILTER_XTABLES NETFILTER_XT_TARGET_NFQUEUE IP_NF_IPTABLES IP_NF_FILTER"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	emake CC=$(tc-getCC) || die "emake failed"
}

src_install() {
	dosbin moblock
	dosbin "${FILESDIR}/${PVR}/moblock-update"
	dosbin "${FILESDIR}/${PVR}/moblock-stats"

	newconfd "${FILESDIR}/${PVR}/confd" moblock
	newinitd "${FILESDIR}/${PVR}/initd" moblock

	dodir /var/db/moblock
	touch "${D}/var/db/moblock/guarding.p2p"

	keepdir /var/cache/moblock

	dodoc Changelog README
}

pkg_postinst() {
	elog "Run moblock-update to update your block list."
	elog "You can set moblock to update daily with the command"
	elog "  ln -s /usr/sbin/moblock-update /etc/cron.daily/moblock-update"
	elog "Or weekly with"
	elog "  ln -s /usr/sbin/moblock-update /etc/cron.weekly/moblock-update"
}

pkg_postrm() {
	if ! has_version ${CATEGORY}/${PN} && [[ -d ${ROOT}/var/cache/moblock ]] ; then
		einfo "Removing leftover cache..."
		rm -rf "${ROOT}"/var/cache/moblock
	fi
}
