# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit qt4-r2

DESCRIPTION="cross-platform serial port class"
HOMEPAGE="http://code.google.com/p/qextserialport/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

RDEPEND="dev-qt/qtcore:4"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-install.patch"
)

S=${WORKDIR}/${PN}

src_install() {
	qt4-r2_src_install
	dolib build/libqextserialport* || die
	if use doc ; then
		dohtml html/* || die
	fi
	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/* || die
	fi
}
