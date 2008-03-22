# Copyright 2006-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

QT4_BUILT_WITH_USE_CHECK="gif jpeg png sqlite3"

inherit qt4

MY_P="GR-lida-${PV}"

DESCRIPTION="Frontend for scummvm and dosbox"
HOMEPAGE="http://www.laisladelabandoware.es"
SRC_URI="http://dl.sharesource.org/grlida/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dosbox scummvm"

DEPEND="$(qt4_min_version 4.3)"
RDEPEND="${DEPEND}
	dosbox? ( games-emulation/dosbox )
	scummvm? ( games-engines/scummvm )"
S="${WORKDIR}"/"${MY_P}"

src_compile(){
	eqmake4
	emake || die "Compile Failed"
}

src_install(){
	emake INSTALL_ROOT="${D}" install || die "Install Failed"
}

pkg_postinst(){
	einfo "The GUI is currently in Spanish."
	einfo "See bug 213983 for instructions about translation."
}
