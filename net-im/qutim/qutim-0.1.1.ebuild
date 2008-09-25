# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit eutils qt4 flag-o-matic
MY_PN="${PN/im/IM}"

DESCRIPTION="New Qt4-based Instant Messenger (ICQ)."
HOMEPAGE="http://www.qutim.org"
LICENSE="GPL-2"
SRC_URI="http://www.qutim.org/download/${P/-/_}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="|| ( x11-libs/qt-gui:4 =x11-libs/qt-4.3* )"
QT4_BUILT_WITH_USE_CHECK="png gif"

S="${WORKDIR}/${P/-/_}"

src_compile() {
	if use debug; then
		replace-flags -O* -O0
		append-flags -g -ggdb
	fi

	eqmake4 ${MY_PN}.pro
	emake || die "emake failed"
}

src_install(){
	newbin build/bin/${MY_PN} ${PN} || die "Installation failed"

	# Creating Desktop Entry. Thanks to hajit from qutim-forum for it.
	doicon icons/${PN}_64.png || die "Failed to install icon"
	make_desktop_entry ${PN} ${MY_PN} ${PN}_64.png "Network;InstantMessaging;Qt" || die "Failed to create a shourtcut"
}
