# Copyright 2006-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit qt4

MY_P="GR-lida-${PV}"
S="${WORKDIR}"/"${MY_P}"

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

QT4_BUILT_WITH_USE_CHECK="gif jpeg png sqlite3"

src_compile(){
	eqmake4 "${PN}".pro || die
	emake || die "Compile Failed"
}

src_install(){
	emake INSTALL_ROOT="${D}" install || die "Install Failed"
}

pkg_postinst(){
	einfo "The GUI is by default in Spanish."
	einfo "If you need it, English is available on the Options Menu."
}
