# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2 versionator

MY_PN="LaTeXDraw"
MY_PV=$(get_version_component_range 1-2)$(get_version_component_range 4 ${PV/alpha/a})

MY_P=${MY_PN}${MY_PV}_src
DESCRIPTION="graphical drawing editor for latex"
HOMEPAGE="http://latexdraw.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMONDEPEND="dev-java/jlibeps:0
	>=dev-java/pdf-renderer-0.9.1:0"

RDEPEND=">=virtual/jre-1.6
	${COMMONDEPEND}"

DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${COMMONDEPEND}"

S="${WORKDIR}"/${MY_P}

EANT_GENTOO_CLASSPATH="jlibeps pdf-renderer"
EANT_DOC_TARGET="doc"
JAVA_ANT_REWRITE_CLASSPATH="yes"
java_prepare() {
	epatch "${FILESDIR}"/${P}-java6.patch "${FILESDIR}"/${PN}-build.xml.patch
	rm lib/*.jar || die
}
src_install() {
	use doc && java-pkg_dojavadoc doc
	use source && java-pkg_dosrc src/{net,org}
	cd out/data || die
	java-pkg_dojar ${MY_PN}.jar
	insinto /usr/share/${PN}
	doins -r templates
	java-pkg_dolauncher ${PN} --main net.sf.${PN}.${MY_PN}
}
