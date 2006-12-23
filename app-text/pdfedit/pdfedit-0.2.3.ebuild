# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils qt3

DESCRIPTION="Linux pdf editor."
HOMEPAGE="http://pdfedit.petricek.net"
SRC_URI="http://pdfedit.petricek.net/dl/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

IUSE=""
RDEPEND="$(qt_min_version 3.3)"
DEPEND="${RDEPEND}
	dev-libs/boost"

src_unpack(){
	 unpack ${A}
	 cd "${S}"
	 epatch "${FILESDIR}/${P}-build-fix.patch"
}

src_compile(){
	econf || die "econf failed"
	emake src || die "emake failed"
}

src_install() {
	emake install INSTALL_ROOT="${D}" || die "emake install failed"
}
