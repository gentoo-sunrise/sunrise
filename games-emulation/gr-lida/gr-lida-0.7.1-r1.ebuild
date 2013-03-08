# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit qt4-r2

MY_P="GR-lida-${PV}"

DESCRIPTION="Frontend for scummvm and dosbox"
HOMEPAGE="http://www.laisladelabandoware.es"
SRC_URI="http://dl.sharesource.org/grlida/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dosbox scummvm"

DEPEND="dev-qt/qtgui:4
	dev-qt/qtsql:4[sqlite]
	dosbox? ( games-emulation/dosbox )
	scummvm? ( games-engines/scummvm )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

pkg_postinst(){
	elog "The GUI is by default in Spanish."
	elog "If you need it, English is available on the Options Menu."
}
