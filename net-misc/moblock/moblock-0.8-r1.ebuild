# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs linux-info

KEYWORDS="~amd64 ~x86"

MY_P=${P/mob/MoB}

DESCRIPTION="A linux console application that blocks connections from/to hosts listed in a file in peerguardian format using iptables."
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

check_kernel_config() {
	if !(linux_chkconfig_present NETFILTER \
			&& linux_chkconfig_present NETFILTER_XTABLES \
			&& linux_chkconfig_present NETFILTER_XT_TARGET_NFQUEUE \
			&& linux_chkconfig_present IP_NF_IPTABLES \
			&& linux_chkconfig_present IP_NF_FILTER); then
		eerror
		eerror "${P} requires the following kernel options:"
		eerror "    CONFIG_NETFILTER"
		eerror "    CONFIG_NETFILTER_XTABLES"
		eerror "    CONFIG_NETFILTER_XT_TARGET_NFQUEUE"
		eerror "    CONFIG_IP_NF_IPTABLES"
		eerror "    CONFIG_IP_NF_FILTER"
		eerror
		die "Missing kernel components"
	fi
}

src_unpack() {
	check_kernel_config
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	emake CC=$(tc-getCC) || die "emake failed"
}


# TODO: Should we be doing touch on the blocklist and log files?  This causes
# them to be deleted when unmerged.
src_install() {
	dosbin moblock
	dosbin "${FILESDIR}/${PVR}/moblock-update"
	dosbin "${FILESDIR}/${PVR}/moblock-stats"

	newconfd "${FILESDIR}/${PVR}/confd" moblock
	newinitd "${FILESDIR}/${PVR}/initd" moblock

	dodir /var/db/moblock
	touch "${D}/var/db/moblock/p2p.p2p" \
		|| die "touch ${D}/var/db/moblock/p2p.p2p"

	keepdir /var/cache/moblock

	#dodir /var/log
	#touch "${D}/var/log/moblock.log" \
	#	|| die "touch ${D}/var/log/moblock.log"

	#touch "${D}/var/log/moblock-update.log" \
	#	|| die "touch ${D}/var/log/moblock-update.log"

	#touch "${D}/var/log/MoBlock.stats" \
	#	|| die "touch ${D}/var/log/MoBlock.stats"

	dodoc Changelog README
}

pkg_postinst() {
	elog "Run moblock-update to update your block list."
	elog "You can set moblock to update daily with the command"
	elog "  ln -s /usr/sbin/moblock-update /etc/cron.daily/moblock-update"
	elog "Or weekly with"
	elog "  ln -s /usr/sbin/moblock-update /etc/cron.weekly/moblock-update"
}

# TODO: Should we remove downloaded/cached files?
#pkg_postrm() {
#	rm -rf /var/cache/moblock
#	return
#}
