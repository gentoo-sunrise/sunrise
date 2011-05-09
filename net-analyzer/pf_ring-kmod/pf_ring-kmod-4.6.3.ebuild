# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit linux-mod linux-info

DESCRIPTION="A new type of network socket that improves packet capture speed."
HOMEPAGE="http://www.ntop.org/PF_RING.html"
SRC_URI="http://sourceforge.net/projects/ntop/files/PF_RING/PF_RING-${PV}.tar.gz/download -> PF_RING-4.6.3.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}/PF_RING-${PV}/kernel"

MODULE_NAMES="pf_ring(net/pf_ring:${S}:${S})"
CONFIG_CHECK="NET"
ERROR_NET="PF_RING-${PV} requires CONFIG_NET=y set in the kernel."
BUILD_TARGETS="modules"

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="-C ${KV_DIR} SUBDIRS=${S} EXTRA_CFLAGS='-I${S}'"
}

src_install() {
	linux-mod_src_install
	insinto /usr/include/linux
	doins linux/pf_ring.h || die
	insinto /etc/modprobe.d
	doins "${FILESDIR}"/pf_ring.conf || die
	sed -i -e 's:DOCDIR:/usr/share/doc/'${PF}'/README.module_options:g' \
		"${D}etc/modprobe.d/pf_ring.conf" || die
	dodoc "${FILESDIR}"/README.module_options || die
}

pkg_postinst() {
	einfo "Please see /usr/share/doc/${PF}/README.module_options for configuration options."
	linux-mod_pkg_postinst
}
