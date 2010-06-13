# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2

MY_PV=${PV//./_}
MY_P=smartsvn-generic-${MY_PV}

DESCRIPTION="GUI to SVN with extensive merge support and commit wizard"
HOMEPAGE="http://www.syntevo.com/smartsvn/"
SRC_URI="${MY_P}.tar.gz"
SLOT="0"
LICENSE="smartsvn"
KEYWORDS="~amd64 ~x86"

IUSE=""
RESTRICT="fetch"

RDEPEND=">=virtual/jre-1.4.1"

S="${WORKDIR}/${PN}-${MY_PV}"

src_install() {
	local rdir="/opt/${PN}"
	insinto ${rdir}
	doins -r * || die "cannot install needed files"

	java-pkg_regjar ${rdir}/lib/${PN}.jar

	java-pkg_dolauncher ${PN} "--java-args -Xmx256 --jar ${PN}.jar"

	for X in 32 48 64 128
	do
		insinto /usr/share/icons/hicolor/${X}x${X}/apps
		newins "${S}/bin/${PN}-${X}.png" "${PN}.png" || die "cannot install needed files"
		insinto /usr/share/icons/hicolor/scalable/apps
		newins "${S}/bin/${PN}.svg" "${PN}.svg" || die "cannot install needed files"
	done

	make_desktop_entry "${PN}" "SmartSVN" ${PN} "Development;RevisionControl" || die "cannot create desktop entry"
}

pkg_nofetch(){
	einfo "Please download ${MY_P}.tar.gz from:"
	einfo "${HOMEPAGE}download.html?file=smartsvn/${MY_P}.tar.gz"
	einfo "and move/copy to ${DISTDIR}"
}
