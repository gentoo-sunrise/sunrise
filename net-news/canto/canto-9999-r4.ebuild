# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

NEED_PYTHON="2.5"

inherit git distutils

DESCRIPTION="Ncurses RSS client"
HOMEPAGE="http://www.codezen.org/canto/"
EGIT_REPO_URI="git://codezen.org/git/${PN}"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sys-libs/ncurses[unicode]
		dev-python/chardet"
RDEPEND="${DEPEND}"

src_unpack() {
	git_src_unpack
}
