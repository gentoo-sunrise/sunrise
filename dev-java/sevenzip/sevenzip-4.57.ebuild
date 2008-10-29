# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java code for LZMA compression and decompression"
HOMEPAGE="http://www.7-zip.org/"
SRC_URI="mirror://sourceforge/${PN}/lzma${PV/./}.tar.bz2"

LICENSE="LGPL-2.1 CPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5
	app-arch/bzip2"
S=${WORKDIR}/Java/SevenZip

src_unpack() {
	unpack ${A}
	cd "${S}"
	cp "${FILESDIR}"/build.xml .
}

src_install() {
	java-pkg_dojar "${PN}.jar"
}

