# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic java-pkg-2 toolchain-funcs

DESCRIPTION="Forward error correction libs"
HOMEPAGE="http://www.onionnetworks.com/developers/"
SRC_URI="http://www.onionnetworks.com/downloads/${P}.zip
	http://dev.gentooexperimental.org/~tommy/distfiles/${P}.zip"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="-amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"
S=${WORKDIR}/${P}/src/csrc/

src_compile() {
	append-flags -fPIC
	emake CC=$(tc-getCC) CFLAGS="${CFLAGS}" || die
}

src_install() {
	dolib.so ../../lib/fec-linux-x86/lib/linux/x86/libfec{8,16}.so
}
