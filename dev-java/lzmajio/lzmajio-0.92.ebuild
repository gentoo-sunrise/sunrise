# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 java-ant-2

DESCRIPTION="Implementations of LzmaInputStream/LzmaOutputStream interacting with underlying LZMA en-/decoders"
HOMEPAGE="http://contrapunctus.net/league/haques/lzmajio/"
SRC_URI="http://comsci.liu.edu/~league/dist/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

COMMON_DEP="dev-java/sevenzip"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${COMMON_DEP}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	java-pkg_jar-from sevenzip
	cp "${FILESDIR}"/build.xml .
}

src_install() {
	java-pkg_dojar "${PN}.jar"
}

