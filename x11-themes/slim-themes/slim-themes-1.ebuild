# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="SLiM (Simple Login Manager) themes pack"
HOMEPAGE="http://slim.berlios.de/"
SRC_URI="http://download.berlios.de/slim/slim-lunar-0.4.tar.bz2
	http://download.berlios.de/slim/slim-archlinux.tar.gz
	http://download.berlios.de/slim/slim-zenwalk.tar.gz
	http://download.berlios.de/slim/slim-parallel-dimensions.tar.gz
	http://download.berlios.de/slim/slim-capernoited.tar.gz
	http://download.berlios.de/slim/slim-mindlock.tar.gz
	http://download.berlios.de/slim/slim-flower2.tar.gz"
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
	cp -R . ${D}/${themesdir}
}
