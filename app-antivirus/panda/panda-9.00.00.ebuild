# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Panda Antivirus for Linux"
HOMEPAGE="http://www.pandasoftware.com/download/linux/linux.asp"
SRC_URI="http://shareware.pandasoftware.com/shareware/pavcl_linux.tgz"

SLOT="0"
LICENSE="Panda-Freeware"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""
PROVIDE="virtual/antivirus"

RESTRICT="mirror strip"
QA_TEXTRELS_x86="opt/pavcl/usr/lib/libPsk*.so.*"
S="${WORKDIR}"

src_install() {
	cp -r . "${D}"

	dodir /etc/env.d
	echo "PATH=\"/opt/pavcl/usr/bin\"" >> "${D}"/etc/env.d/90panda
	echo "MANPATH=\"/opt/pavcl/usr/man\"" >> "${D}"/etc/env.d/90panda
}

pkg_postinst() {
	elog "See \"man pavcl\" for usage instructions."
	elog
	elog "Updated virus definitions are not available for free."
	elog "You need a username and password to download them"
	elog "from http://acs.pandasoftware.com/software/basevirus/"
}

pkg_postrm() {
	if ! has_version ${CATEGORY}/${PN} && [[ -d "${ROOT}/opt/pavcl/var/log/panda" ]] ; then
		einfo "Removing stale logdir..."
		rm -rf "${ROOT}/opt/pavcl/var/log/panda"
	fi
}
