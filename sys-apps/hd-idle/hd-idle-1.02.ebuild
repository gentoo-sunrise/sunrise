# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="Utility for spinning down hard disks after a period of idle time"
HOMEPAGE="http://hd-idle.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${PN}

src_compile() {
	# CC_DEBUG is now used with linking only, so it's a good place
	# to push the LDFLAGS into.
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" CC_DEBUG="${LDFLAGS}" || die
}

src_install() {
	dosbin hd-idle || die "dosbin failed"
	newinitd "${FILESDIR}"/hd-idle-init hd-idle || die "newinitd failed"
	newconfd "${FILESDIR}"/hd-idle-conf hd-idle || die "newconfd failed"
}

pkg_postinst() {
	if [[ ! -f /proc/diskstats ]]
	then
		ewarn "Please note that hd-idle uses /proc/diskstats to read disk"
		ewarn "statistics. If this file is not present, hd-idle won't work."
		ewarn "You should check your kernel configuration and make sure"
		ewarn "it includes CONFIG_PROC_FS=y."
	fi
}
