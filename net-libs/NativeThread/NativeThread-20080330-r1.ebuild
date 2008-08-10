# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic java-pkg-2 toolchain-funcs

DESCRIPTION="NativeThread for priorities on linux for freenet"
HOMEPAGE="http://www.freenetproject.org/"
SRC_URI="http://dev.gentooexperimental.org/~tommy/distfiles/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-p2p/freenet
	>=virtual/jdk-1.4"
RDEPEND=""

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/Makefile.patch
}

src_compile() {
	append-ldflags -fPIC
	tc-export CC
	emake || die
}

src_install() {
	dolib.so libNativeThread.so
}
