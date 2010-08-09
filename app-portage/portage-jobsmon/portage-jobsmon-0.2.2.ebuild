# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

PYTHON_DEPEND='*:2.6'
PYTHON_USE_WITH=ncurses
inherit python

DESCRIPTION="Track parallel merges and display their logs on a split-screen basis"
HOMEPAGE="http://github.com/mgorny/portage-jobsmon/"
SRC_URI="http://github.com/downloads/mgorny/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-python/pyinotify"

src_install() {
	newbin ${PN}.py ${PN} || die
}
