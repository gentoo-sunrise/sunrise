# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2

MY_PV=${PV//./_}
MY_P=smartcvs-generic-${MY_PV}

DESCRIPTION="SmartCVS"
HOMEPAGE="http://www.syntevo.com/smartcvs/"
SRC_URI="${MY_P}.tar.gz"
SLOT="0"
LICENSE="smartcvs"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="fetch"

RDEPEND=">=virtual/jre-1.4.1"

S="${WORKDIR}/${PN}-${MY_PV}"

src_install() {
	local rdir="/opt/${PN}"
	insinto ${rdir}
	doins -r * || die
	java-pkg_regjar ${rdir}/lib/${PN}.jar
	java-pkg_dolauncher ${PN} "--java-args -Xmx256 --jar ${PN}.jar"
	for X in 32 48 64 128
	do
		insinto /usr/share/icons/hicolor/${X}x${X}/apps
		newins "${S}/bin/${PN}-${X}x${X}.png" "${PN}.png" || die "cannot install needed files"
	done
	make_desktop_entry ${PN} "SmartCVS" ${PN}.png "Development;RevisionControl"
}

pkg_nofetch() {
	einfo "Please download ${MY_P}.tar.gz from:"
	einfo "http://www.syntevo.com/smartcvs/download.html?file=smartcvs%2Fsmartcvs-generic-${MY_PV}.tar.gz"
	einfo "and move/copy to ${DISTDIR}"
}
