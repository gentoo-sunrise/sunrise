# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2

DESCRIPTION="an efficient universal simulator of neural networks"
HOMEPAGE="http://www-ra.informatik.uni-tuebingen.de/software/JavaNNS/welcome_e.html"
SRC_URI="http://ndansmith.net/software/${PN}/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND="${RDEPEND}
	>=virtual/jdk-1.4
	dev-java/ant"

MY_PN="JavaNNS"

S="${WORKDIR}/${MY_PN}"

src_unpack() {
	unpack ${A}
	cp "${FILESDIR}/target.def" "${S}/"
	cd "${S}"
	rm manual/*.pdf
}

src_install() {
	java-pkg_dojar dist/JavaNNS.jar

	java-pkg_dolauncher ${MY_PN}
	
	dodoc COPYRIGHT.txt
	dohtml manual/*
}

pkg_postinst() {
	echo
	einfo "In order to be able to use the User Manual from within the"
	einfo "simulator, you may have to adjust some of the JavaNNS properties."
	einfo "Use View/Properties menu in JavaNNS and consult the User Manual for"
	einfo "further details."
	echo
}
