# Copyright 1999-2010 Gentoo Foundation                             
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Software designed for automatic management of downloads and uploads at hosting sites like rapidshare or megaupload"
HOMEPAGE="http://tucaneando.com/"
SRC_URI="http://forja.rediris.es/frs/download.php/1470/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="gtk"
RDEPEND="dev-lang/python
	gtk? ( dev-python/pygtk
		gnome-base/librsvg )
	app-text/tesseract[linguas_en]
	dev-python/imaging"

src_compile() { :; }

src_install() {
	emake DESTDIR="${D}"/usr install || die "emake install failed"
	dodoc CHANGELOG README || die "dodoc failed"
	newicon media/tucan.svg "${PN}.svg" || die "newicon failed"
	if use gtk ; then
		make_desktop_entry tucan Tucan
	fi
}
