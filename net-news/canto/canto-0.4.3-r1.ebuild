# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON="2.4"
inherit distutils

DESCRIPTION="Ncurses RSS client"
HOMEPAGE="http://www.codezen.org/canto/"
SRC_URI="http://codezen.org/static/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-libs/ncurses"

src_install() {
	sed -i "s:SETUPPY_SET_MAN_PATH:\"\":g" canto/cfg.py || die
	sed -i "s:SETUPPY_SET_BIN_PATH:\"/usr/bin/\":g" canto/cfg.py || die
	sed -i "s:/canto.1:canto:g" canto/gui.py || die

	distutils_src_install
}

pkg_postinst() {
	ewarn "NOTE: If you're updating from a previous version canto <= 0.4.1"
	ewarn "you must 'rm -rf ~/.canto/feeds' as the on-disk format has"
	ewarn "changed. Sorry for the inconvenience."
}
