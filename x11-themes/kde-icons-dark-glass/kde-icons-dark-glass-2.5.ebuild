# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_PN="${PN/kde-icons-}"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Glass-style icons for KDE."
HOMEPAGE="http://www.kde-look.org/content/show.php/Dark-Glass+reviewed?content=67902"
SRC_URI="http://dev.gentooexperimental.org/~jakub/distfiles/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="binchecks strip"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm -f buildset*
	edos2unix index.desktop
	sed -i -e '/^SmallDefault=/s:32:16:' index.desktop
}

src_compile() {
	einfo "Nothing to compile, installing. This will take a while..."
}

src_install() {
	insinto /usr/share/icons/${MY_PN}
	doins -r "${S}"/*
}
