# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 java-ant-2

DESCRIPTION="Forword error correction libs"
HOMEPAGE="http://www.onionnetworks.com/developers/"
SRC_URI="http://www.onionnetworks.com/downloads/${P}.zip"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	dev-java/log4j
	dev-java/concurrent-util"

src_unpack() {
	unpack ${A}
	cd "${S}"
	cp "${FILESDIR}"/build.xml src/
	epatch "${FILESDIR}"/libfec8path.patch
	sed -i -e 's/build.compiler=jikes/#build.compiler=jikes/g' build.properties
	cd lib
	rm -rf *
	java-pkg_jar-from --build-only log4j
	java-pkg_jar-from --build-only concurrent-util concurrent.jar concurrent-jaxed.jar

	cd "${S}"
	unzip -q common-20020926.zip
	cd common-20020926
	sed -i -e 's/build.compiler=jikes/#build.compiler=jikes/g' build.properties
	cd lib
	rm -f *jar
}

src_compile() {
	cd common-20020926
	eant clean jars
	cp lib/onion-common.jar "${S}"/lib/
	cd "${S}"
	eant clean jars
	cd src
	eant
}

src_install() {
	java-pkg_dojar src/${PN}.jar
}
