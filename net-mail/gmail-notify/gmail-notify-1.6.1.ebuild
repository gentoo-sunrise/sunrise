# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit python

DESCRIPTION="Gmail Notifier is a Linux alternative for the notifier program released by Google"
HOMEPAGE="http://gmail-notify.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="virtual/python
	>=dev-python/pygtk-2.0*
	>=x11-libs/gtk+-2.4*"
DEPEND="${RDEPEND}
	app-arch/bzip2"

S=${WORKDIR}/${PN}

src_install() {
	python_version
	INST_DIR=/usr/lib/python${PYVER}/site-packages/${PN}

	#Install docs
	dodoc README
	rm -f README

	#Install all python files into site-packages
	insinto ${INST_DIR}
	doins -r *

	#Install a script in /usr/bin
	echo "#!/bin/bash" > gmail-notify
	echo "exec /usr/bin/python ${INST_DIR}/notifier.py \"\$1\"" >> gmail-notify
	dobin gmail-notify
}

pkg_postinst() {
	python_version
	python_mod_optimize /usr/lib/python${PYVER}/site-packages/${PN}
	einfo "Run gmail-notify to start the program"
	einfo ""
	einfo "Warning: if you check the 'save username and password' option"
	einfo "your password will be stored in plaintext in ~/.notifier.conf"
	einfo "with world-readable permissions. If this concerns you, do not"
	einfo "check the 'save username and password' option."
}

pkg_postrm() {
	python_version
	python_mod_cleanup /usr/lib/python${PYVER}/site-packages/${PN}
}
