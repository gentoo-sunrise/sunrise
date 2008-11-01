# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils latex-package java-pkg-2 java-ant-2

MY_PV=${PV//./}
MY_PV=${MY_PV/_/}
MY_P=${PN}${MY_PV}

DESCRIPTION="Writer2Latex (w2l) - converter from OpenDocument .odt format"
HOMEPAGE="http://www.hj-gym.dk/~hj/writer2latex"
SRC_URI="http://www.hj-gym.dk/~hj/${PN}/${MY_P}.zip
		http://fc.hj-gym.dk/~hj/${MY_P}.zip"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE="doc examples"

DEPEND="=virtual/jdk-1.4*
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.4"

S=${WORKDIR}/${PN}05

src_unpack(){
	unpack ${A}
	cd "${S}"
	rm ${PN}.jar
	sed -i -e "s:W2LPATH=.*:W2LPATH=/usr/lib/${PN}:" "${S}"/w2l || die "Sed failed"
}

EANT_EXTRA_ARGS="-DOFFICE_HOME=/usr/lib/openoffice"
EANT_BUILD_TARGET="all"

src_install() {

	dobin w2l

	rm build.xml
	insinto /usr/lib/${PN}
	doins *.xml
	doins *.xsl
	java-pkg_jarinto /usr/lib/${PN}
	java-pkg_dojar "${S}/target/lib/${PN}.jar"

	cd "${S}"
	latex-package_src_install

	if use doc ; then
		dohtml -r doc
		cp doc/*.pdf "${D}"/usr/share/doc/${PF} || die "Failed to copy .pdfs"
		cp doc/*.odt "${D}"/usr/share/doc/${PF} || die "Failed to copy .odts"

		java-pkg_dojavadoc target/javadoc

	fi
	if use examples; then
		cp -R samples "${D}"/usr/share/doc/${PF} || die "Failed to copy samples"
	fi

	dodoc History.txt Readme.txt changelog05.txt
}
