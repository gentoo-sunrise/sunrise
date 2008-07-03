# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit python

DESCRIPTION="Ncurses RSS client"
HOMEPAGE="http://www.codezen.org/canto/"
SRC_URI="http://codezen.org/static/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-lang/python-2.4
	sys-libs/ncurses"

RDEPEND=">=dev-lang/python-2.4"

src_install() {
	python_version
	python setup.py install \
		--root="${D}" \
		--prefix="/usr" \
		--install-lib=/usr/lib/python${PYVER}/site-packages \
		|| die "Setup.py Install Failed."
}
