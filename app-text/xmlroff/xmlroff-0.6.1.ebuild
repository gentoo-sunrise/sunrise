# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A fast, free, high-quality, multi-platform XSL formatter"
HOMEPAGE="http://xmlroff.org/"
SRC_URI="http://xmlroff.org/download/${P}.tar.gz"

LICENSE="sun-xmlroff"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"

DEPEND=">=x11-libs/pango-1.6.0
	>=media-libs/freetype-2.1.7
	>=media-libs/fontconfig-2.2.0
	>=dev-libs/glib-2.2.0
	>=dev-libs/libxml2-2.6.7
	>=dev-libs/libxslt-1.1.2
	>=gnome-base/libgnomeprint-2.8.0
	>=x11-libs/cairo-1.6.4-r1
	x11-libs/gtk+"
RDEPEND="${DEPEND}"

src_install() {
	einstall HTML_DIR="${D}/usr/share/doc/${P}" || die
	if use doc; then
		mv "${D}/usr/share/doc/${P}/${PN}" "${D}/usr/share/doc/${P}/html" || die
		dodoc ChangeLog
	else
		rm -r "${D}/usr/share/doc/${P}/${PN}" || die
	fi
	dodoc AUTHORS NEWS README TODO
}
