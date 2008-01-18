# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Webpage image gallery creation perl script"
HOMEPAGE="http://bbgallery.sourceforge.net/"
SRC_URI="mirror://sourceforge/bbgallery/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE=""

RDEPEND="dev-lang/perl
	media-gfx/imagemagick
	dev-perl/URI
	dev-perl/libwww-perl
	dev-perl/HTML-Template
	dev-perl/HTML-Parser"

DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/bbgallery-1.2.0.patch
}

src_install() {
	INSPATH="/usr/share/bbgallery"
	dobin bbgallery || die "dobin failed"
	newbin Contrib/JPG2jpg.pl JPG2jpg || die "newbin failed"
	exeinto "${INSPATH}"
	doexe gimp_scale.pl || die "doexe failed"
	insinto "${INSPATH}"
	doins -r template/
	dosym "${INSPATH}"/template/monochrome "${INSPATH}"/template/default \
		|| die "dosym failed"
	dodoc CHANGELOG CREDITS README
	dohtml doc/*.html
}
