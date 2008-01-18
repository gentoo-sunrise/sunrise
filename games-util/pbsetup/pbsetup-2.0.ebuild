# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Updating PunkBuster"
HOMEPAGE="http://www.evenbalance.com/index.php?page=pbsetup.php"
SRC_URI="http://websec.evenbalance.com/downloads/linux/pbsetup.run"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}

src_unpack() {
	cp "${DISTDIR}/${A}" "${S}"
}

src_install() {
	exeinto /usr/share/${PN}
	doexe pbsetup.run
	dobin "${FILESDIR}"/pbsetup
}
