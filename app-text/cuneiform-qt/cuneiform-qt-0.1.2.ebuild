# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit qt4

DESCRIPTION="Qt interface for Cuneiform"
HOMEPAGE="http://www.altlinux.org/Cuneiform-Qt"
SRC_URI="mirror://sourceforge/cuneiform-qt/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=x11-libs/qt-gui-4.4
	app-text/cuneiform"
RDEPEND="${DEPEND}"

src_compile () {
	sed 's:/share/apps/cuneiform-qt/:/share/cuneiform-qt/:' -i cuneiform-qt.pro || die "Cannot patch cuneiform-qt.pro"
	PREFIX="/usr" eqmake4 || die "Cannot run qmake"
	emake || die "Cannot run make"
}

src_install() {
	dodoc AUTHORS README TODO || die "Cannot install docs"
	INSTALL_ROOT="${D}" emake install || die "Cannot install"
}

