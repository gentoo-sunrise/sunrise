# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils python multilib

DESCRIPTION="FTP client in Python and GTK."
HOMEPAGE="http://foff.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
S=${WORKDIR}/${PN}

DEPEND=">=dev-lang/python-2.3
	>=dev-python/pygtk-2.6"
RDEPEND="${DEPEND}"

src_install() {
	# Copying.txt is needed by the about window
	insinto "/usr/$(get_libdir)/${PN}"
	doins *.py foff_logo00.png *.glade *.gladep Copying.txt

	# The app needs to be executed from the installed dir
	echo -e "#!/bin/bash \ncd "/usr/$(get_libdir)/${PN}" \n\
/usr/bin/python ${PN}.py" >> foff

	dobin foff
	dodoc Readme.txt ChangeLog.txt
}

pkg_postinst() {
	python_mod_optimize "${ROOT}usr/$(get_libdir)/${PN}"
}

pkg_postrm() {
	python_mod_cleanup "${ROOT}usr/$(get_libdir)/${PN}"
}
