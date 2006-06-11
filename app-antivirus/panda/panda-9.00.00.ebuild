# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

S="${WORKDIR}"

DESCRIPTION="Panda Antivirus for Linux"
HOMEPAGE="http://www.pandasoftware.com/download/linux/linux.asp"
SRC_URI="http://shareware.pandasoftware.com/shareware/pavcl_linux.tgz"

SLOT="0"
LICENSE="Panda-Freeware"
KEYWORDS="-* ~x86"
IUSE=""

DEPEND=""
RDEPEND=""
PROVIDE="virtual/antivirus"

RESTRICT="mirror strip"
QA_TEXTRELS_x86="opt/pavcl/usr/lib/libPsk*.so.*"

src_install() {
	cd "${S}"
	cp -r . ${D}

	dodir /etc/env.d
	echo "PATH=\"/opt/pavcl/usr/bin\"" >> ${D}/etc/env.d/90panda
	echo "MANPATH=\"/opt/pavcl/usr/man\"" >> ${D}/etc/env.d/90panda
}

pkg_postinst() {
	einfo "See \"man pavcl\" for usage instructions."
	einfo
	einfo "Updated virus definitions are not available for free."
	einfo "You need a username and password to download them"
	einfo "from http://acs.pandasoftware.com/software/basevirus/"
}

pkg_prerm() {
	einfo "Removing stale logdir..."
	[[ -d "${ROOT}/opt/pavcl/var/log/panda" ]] && rm -rf "${ROOT}/opt/pavcl/var/log/panda"
}
