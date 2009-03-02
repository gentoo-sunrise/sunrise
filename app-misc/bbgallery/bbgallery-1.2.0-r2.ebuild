# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Webpage image gallery creation perl script"
HOMEPAGE="http://bbgallery.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE="doc"

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
	epatch "${FILESDIR}/${P}-path-fix.patch"
}

src_install() {
	local inspath="/usr/share/${PN}"

	dobin ${PN} || die "dobin failed"
	newbin Contrib/JPG2jpg.pl JPG2jpg || die "newbin failed"

	exeinto "${inspath}"
	doexe gimp_scale.pl || die "doexe failed"

	insinto "${inspath}"
	doins -r template/ || die "doins failed"
	dosym "${inspath}"/template/monochrome "${inspath}"/template/default \
		|| die "dosym failed"

	dodoc CHANGELOG CREDITS README || die "dodoc failed"
	if use doc; then
		dohtml -r doc/ || die "dohtml failed"
	fi
}
