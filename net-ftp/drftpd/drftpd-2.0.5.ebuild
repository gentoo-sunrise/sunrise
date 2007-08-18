# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A Distributed FTP server written in java."
HOMEPAGE="http://www.drftpd.org"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="slave"

COMMON_DEP=">=dev-java/log4j-1.2.8
	>=dev-java/jdom-1.0
	>=dev-java/xstream-1.2
	>=dev-java/jakarta-oro-2.0.8
	>=dev-java/jsx-1.0.7.5
	>=dev-java/martyr-0.3.9
	>=dev-java/wrapper-3.1.2
	slave? ( >=virtual/jdk-1.4 )
	!slave? ( >=virtual/jdk-1.5 )"

DEPEND=${COMMON_DEP}
RDEPEND=${COMMON_DEP}

src_unpack() {
	unpack ${A}
}

EANT_DOC_TARGET=""

src_install() {
	eant
}

