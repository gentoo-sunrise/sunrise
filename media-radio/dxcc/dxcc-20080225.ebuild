# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A ham radio callsign DXCC lookup utility"
HOMEPAGE="http://fkurz.net/ham/dxcc.html"
SRC_URI="http://fkurz.net/ham/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tk"

RDEPEND="dev-lang/perl
	tk? ( dev-perl/perl-tk )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/Makefile.patch"
}

src_install() {
	emake DESTDIR="${D}/usr" install || die "emake failed"
	doman dxcc.1 || die "doman failed"
	dodoc README ChangeLog || die "dodoc failed"
}
