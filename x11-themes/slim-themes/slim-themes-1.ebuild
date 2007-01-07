# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="SLiM (Simple Login Manager) themes pack"
HOMEPAGE="http://slim.berlios.de/"
SRC_URI="mirror://berlios/slim/slim-lunar-0.4.tar.bz2
	mirror://berlios/slim/slim-archlinux.tar.gz
	mirror://berlios/slim/slim-zenwalk.tar.gz
	mirror://berlios/slim/slim-parallel-dimensions.tar.gz
	mirror://berlios/slim/slim-capernoited.tar.gz
	mirror://berlios/slim/slim-mindlock.tar.gz
	mirror://berlios/slim/slim-flower2.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND="x11-misc/slim"
RDEPEND=""
RESTRICT="strip binchecks"

S=${WORKDIR}

src_compile() {
	einfo "Nothing to compile, installing..."
}

src_install() {
	local themesdir="/usr/share/slim/themes"
	dodir ${themesdir}
	cp -R . "${D}"/${themesdir}
}
