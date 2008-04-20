# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Forword error correction libs"
HOMEPAGE="http://www.onionnetworks.com/developers/"
SRC_URI="http://www.onionnetworks.com/downloads/${P}.zip"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="virtual/jdk"
DEPEND="${RDEPEND}
	app-arch/unzip"
S=${WORKDIR}/${P}/src/csrc/

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/Makefile.patch
}

src_compile() {
	append-flags -fPIC
	tc-export CC
	emake || die
}

src_install() {
	into /opt/freenet
	dolib.so ../../lib/fec-linux-x86/lib/linux/x86/libfec{8,16}.so
}
