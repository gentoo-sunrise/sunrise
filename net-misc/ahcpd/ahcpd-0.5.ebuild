# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="the Ad-Hoc Configuration Protocol"
HOMEPAGE="http://www.pps.jussieu.fr/~jch/software/ahcp/"
SRC_URI="http://www.pps.jussieu.fr/~jch/software/files/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_compile() {
	emake PREFIX=/usr "CDEBUGFLAGS=${CFLAGS}" all || die "build failed"
}

src_install(){
	einstall PREFIX=/usr MANDIR=/usr/share/man INFODIR=/usr/share/info "TARGET=${D}" || die "install failed"
	dodoc CHANGES README || die
}
