# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_PN="PgcEdit"
MY_P="${PN}_source"
MY_PDOC="${MY_PN}_Manual_html"
S="${WORKDIR}"

DESCRIPTION="DVD IFO and Menu editor"
SRC_URI="http://download.videohelp.com/r0lZ/${PN}/${MY_P}.zip
	http://download.videohelp.com/r0lZ/${PN}/versions/${MY_PDOC}.zip"
HOMEPAGE="http://download.videohelp.com/r0lZ/pgcedit/index.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE="video"

RDEPEND=">=dev-lang/tcl-8.4
	>=dev-lang/tk-8.4
	video? ( app-emulation/wine )"

DEPEND="app-arch/unzip"

src_compile() {
	einfo "Nothing to compile!"
}

src_install() {
	edos2unix ${MY_PN}.tcl
	exeinto /usr/share/${PN}
	doexe ${MY_PN}_main.tcl ${MY_PN}.tcl
	make_wrapper ${PN} /usr/share/${PN}/${MY_PN}.tcl /usr/share/${PN}

	keepdir /usr/share/${PN}/plugins
	insinto /usr/share/${PN}
	doins -r bin doc lib

	doicon "${FILESDIR}"/${PN}.png
	make_desktop_entry ${PN} ${MY_PN} ${PN} "AudioVideo;Video;"

	dodoc HISTORY.txt TODO.txt
}
