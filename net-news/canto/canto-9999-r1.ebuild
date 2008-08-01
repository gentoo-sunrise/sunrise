# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils git
NEED_PYTHON="2.4"

DESCRIPTION="Ncurses RSS client"
HOMEPAGE="http://www.codezen.org/canto/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-libs/ncurses"

EGIT_REPO_URI="http://codezen.org/src/canto.git"

src_install() {
	sed -i "s:SETUPPY_SET_MAN_PATH:\"\":g" "${S}/canto/cfg.py" || die
	sed -i "s:SETUPPY_SET_BIN_PATH:\"/usr/bin/\":g" "${S}/canto/cfg.py" || die
	sed -i "s:/canto.1:canto:g" "${S}/canto/gui.py" || die

	distutils_src_install
}
