# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Forword error correction libs"
HOMEPAGE="http://www.onionnetworks.com/developers/"
SRC_URI="http://www.onionnetworks.com/downloads/${P}.zip"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${P}/src/csrc/

append-flags -fPIC
tc-getCC >/dev/null

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/Makefile.patch
}

src_install() {
	into /opt/freenet
	dolib.so ../../lib/fec-linux-x86/lib/linux/x86/libfec{8,16}.so
}
