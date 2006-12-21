# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Contact: Pavel Sanda,  ps at twin.jikos.cz; $

inherit toolchain-funcs

DESCRIPTION="Tool for generating Encapsulated Postscript Format (EPS,EPSF) files from one-page Postscript documents"
HOMEPAGE="http://www.tm.uka.de/~bless/ps2eps"
SRC_URI="http://www.tm.uka.de/~bless/$P.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"

IUSE=""

DEPEND=""

RDEPEND="dev-lang/perl
	     virtual/ghostscript"

S=$WORKDIR/${PN}

src_compile(){
	$(tc-getCC) $CFLAGS $LDFLAGS src/C/bbox.c -o bbox || die
}

src_install() {
	dobin bin/ps2eps
	dobin bbox
	doman doc/man/man1/bbox.1
	doman doc/man/man1/ps2eps.1
	dodoc README.txt
}
