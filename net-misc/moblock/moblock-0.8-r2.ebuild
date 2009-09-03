# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils linux-info toolchain-funcs


MY_P=MoBlock-${PV}

DESCRIPTION="Blocks connections from/to hosts listed in a file in peerguardian format using iptables"
HOMEPAGE="http://moblock.berlios.de/"
SRC_URI="mirror://berlios/${PN}/${MY_P}-i586.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="logrotate network-cron paranoid"

DEPEND="net-libs/libnetfilter_queue
		net-libs/libnfnetlink"
RDEPEND="${DEPEND}
		net-firewall/iptables"

S=${WORKDIR}/${MY_P}

CONFIG_CHECK="NETFILTER NETFILTER_XTABLES NETFILTER_XT_TARGET_NFQUEUE
		IP_NF_IPTABLES IP_NF_FILTER NETFILTER_XT_MATCH_STATE"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/${P}-makefile.patch"
	epatch "${FILESDIR}/${P}-rename-stats-file.patch"
	epatch "${FILESDIR}/${P}-fix-nfq_unbind_pf-error.patch"
	epatch "${FILESDIR}/${P}-fix-broken-compile.patch"
}

src_compile() {
	cd "${S}" || die
	emake CC=$(tc-getCC) || die "emake failed"
}

src_install() {
	dosbin moblock || die

	dosbin "${FILESDIR}/${PVR}/moblock-update" || die
	dosbin "${FILESDIR}/${PVR}/moblock-stats" || die

	newinitd "${FILESDIR}/${PVR}/init.d" moblock || die
	doconfd "${FILESDIR}/${PVR}/moblock.paranoid.example" || die
	doconfd "${FILESDIR}/${PVR}/moblock.normal.example" || die
	doconfd "${FILESDIR}/${PVR}/moblock.minimal.example" || die
	if use paranoid; then
		newconfd "${FILESDIR}/${PVR}/moblock.paranoid.example" moblock || die
	else
		newconfd "${FILESDIR}/${PVR}/moblock.normal.example" moblock || die
	fi

	dodir /var/db/moblock || die
	touch "${D}/var/db/moblock/guarding.p2p" || die

	keepdir /var/cache/moblock || die

	if use network-cron; then
		if use paranoid; then
			dosym /usr/sbin/moblock-update /etc/cron.daily/moblock-update || die
		else
			dosym /usr/sbin/moblock-update /etc/cron.weekly/moblock-update || die
		fi
	fi

	if use logrotate; then
		insinto /etc/logrotate.d || die
		newins "${FILESDIR}/${PVR}/logrotate" moblock || die
	fi

	dodoc Changelog README || die
}

pkg_postinst() {
	if use network-cron; then
		local cron_interval="$(use paranoid && echo daily || echo weekly)";
		elog "The script /usr/sbin/moblock-update will be run ${cron_interval} to update your"
		elog "blocklists.  You can change this by moving or removing the symlink"
		elog "/etc/cron.${cron_interval}/moblock-update or re-installing MoBlock without the"
		elog "network-cron USE flag."
	else
		elog "Run moblock-update to update your block list.  To have this happen"
		elog "automatically, re-install enabling the network-cron USE flag."
	fi
	elog ""
	elog "You can view or change your blocklist(s) and other options by editing"
	elog "/etc/conf.d/moblock."
}

pkg_postrm() {
	if ! has_version ${CATEGORY}/${PN} && [[ -d ${ROOT}/var/cache/moblock ]] ; then
		elog "Removing leftover cache..."
		rm -rf "${ROOT}/var/cache/moblock" ||
			ewarn "Failed to remove ${ROOT}/var/cache/moblock"
	fi
}
