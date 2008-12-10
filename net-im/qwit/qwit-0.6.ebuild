# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit qt4

MY_P=${P}-src

DESCRIPTION="Qt4 cross-platform client for Twitter."
HOMEPAGE="http://code.google.com/p/qwit/"
SRC_URI="http://${PN}.googlecode.com/files/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="|| ( ( x11-libs/qt-core x11-libs/qt-gui ) x11-libs/qt:4 )"

S=${WORKDIR}/${MY_P}

src_install(){
	emake INSTALL_ROOT="${D}" install || die "Install failed"
}
