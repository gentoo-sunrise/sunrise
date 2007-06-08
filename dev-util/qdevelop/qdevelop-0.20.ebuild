# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils qt4 toolchain-funcs

KEYWORDS="~x86"

MY_P=QDevelop-${PV}

DESCRIPTION="A development environment entirely dedicated to Qt4."
HOMEPAGE="http://qdevelop.org/"
SRC_URI="http://qdevelop.org/download/${MY_P}-unstable.zip"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="$(qt4_min_version 4.1)"
DEPEND="app-arch/unzip
		${RDEPEND}"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	if ! built_with_use =x11-libs/qt-4* sqlite; then
		eerror "x11-libs/qt has to be built with sqlite support"
		die "qt sqlite use-flag not set"
	fi
}

src_compile() {
	qmake || die "qmake failed"
	emake CXX=$(tc-getCXX) || die "emake failed"
}

src_install() {
	dodoc ChangeLog.txt README.txt
	dobin bin/QDevelop
}
