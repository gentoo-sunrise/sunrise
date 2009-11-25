# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2

MY_P="${P/-bin/}"
MY_PN="${PN/-bin/}"

DESCRIPTION="Web application testing toolkit utilizing remote-control of a web browser"
HOMEPAGE="http://seleniumhq.org/projects/remote-control/"
SRC_URI="http://release.seleniumhq.org/${MY_PN}/${PV}/${MY_P}-dist.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=">=virtual/jre-1.5
	x11-libs/libX11"

S="${WORKDIR}/${MY_P}"

src_install() {
	java-pkg_newjar selenium-server-${PV}/selenium-server.jar
	java-pkg_dolauncher
}

pkg_postinst() {
	einfo "You will need a browser that selenium remote control can"
	einfo "start and run tests. The list of supported browsers can"
	einfo "be found here:"
	einfo "http://seleniumhq.org/about/platforms.html#browsers"
	einfo ""
	einfo "Note that you must start selenium remote control within"
	einfo "an X session of the user you intend run selenium scripts on."
	einfo ""
	einfo "You can use /usr/bin/selenium-remote-control-bin to start the"
	einfo "selenium remote control."
}
