# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-r2

DESCRIPTION="Linux Vinculum (USB host controller) Programmer"
HOMEPAGE="http://www.sourceforge.net/projects/lvprog/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="x11-libs/qt-gui:4
	dev-libs/libserial"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"
