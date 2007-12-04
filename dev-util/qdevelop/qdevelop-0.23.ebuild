# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit eutils qt4 toolchain-funcs

KEYWORDS="~x86"

MY_P=QDevelop-${PV}-1

DESCRIPTION="A development environment entirely dedicated to Qt4."
HOMEPAGE="http://qdevelop.org/"
SRC_URI="http://qdevelop.org/download/${MY_P}.zip"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND=">=x11-libs/qt-4.2:4"
DEPEND="app-arch/unzip
		${RDEPEND}"

QT4_BUILT_WITH_USE_CHECK="sqlite3"
S=${WORKDIR}/${MY_P}

src_compile() {
	eqmake4
	emake CXX=$(tc-getCXX) || die "emake failed"
}

src_install() {
	dodoc ChangeLog.txt README.txt
	dobin bin/QDevelop
}
