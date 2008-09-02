# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit base java-pkg-2 java-ant-2

DESCRIPTION="Berkeley DB JE is a high performance, transactional storage engine written entirely in Java"
HOMEPAGE="http://www.oracle.com/database/berkeley-db/je/index.html"
SRC_URI="http://download.oracle.com/berkeley-db/${P/db-/}.tar.gz"

LICENSE="as-is"
SLOT="3.2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/jdk-1.5
	!dev-java/db-je"
RDEPEND=">=virtual/jre-1.4"
S="${WORKDIR}/${P/db-/}"

# allows you to disable testing
PATCHES=( "${FILESDIR}/${P}-build.patch" )

src_unpack() {
	base_src_unpack
	cd "${S}"/lib
	rm -v *jar
	java-pkg_jar-from --build-only ant-core ant.jar
}

src_compile() {
	eant jar -Dnotest=true
}

src_install() {
	java-pkg_dojar build/lib/je.jar
	dodoc README
}
