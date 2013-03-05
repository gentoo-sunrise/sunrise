# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit qt4-r2

DESCRIPTION="Linux Vinculum (USB host controller) Programmer"
HOMEPAGE="http://www.sourceforge.net/projects/lvprog/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtgui:4
	dev-libs/libserial"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"
