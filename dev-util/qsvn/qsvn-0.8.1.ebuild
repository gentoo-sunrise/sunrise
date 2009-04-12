# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils cmake-utils

DESCRIPTION="GUI frontend to the Subversion revision system"
HOMEPAGE="http://www.anrichter.net/projects/qsvn/"
SRC_URI="http://www.anrichter.net/projects/${PN}/chrome/site/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="x11-libs/qt-gui:4[qt3support]
	x11-libs/qt-sql:4[sqlite]
	x11-libs/qt-test:4
	dev-util/subversion"
RDEPEND=${DEPEND}

S="${WORKDIR}/${P}/src"

src_prepare() {
	epatch "${FILESDIR}/gcc43.patch"
}

src_install() {
	cmake-utils_src_install
	dodoc ../{ChangeLog,README} || die
}
