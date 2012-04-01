# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools autotools-utils eutils versionator

MY_PV=$(get_version_component_range 1-2)

DESCRIPTION="Extension of Gnome designed to enable a full screen preview of any kind of file"
HOMEPAGE="http://launchpad.net/gloobus-preview"
SRC_URI="http://launchpad.net/gloobus/gloobus-${MY_PV}/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-text/poppler
	gnome-base/libgnomeui
	media-libs/freetype:2
	media-libs/gst-plugins-base:0.10
	media-libs/taglib
	x11-libs/cairo
	x11-libs/gtksourceview:2.0"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-cxxflags.patch
	eautomake
}

src_configure() {
	local myeconfargs=(
		--disable-static
	)
	autotools-utils_src_configure
}

pkg_postinst() {
	elog "To enable Openoffice support, you must install:"
	elog "	app-office/unoconv"
	elog "To enable Nautilus integration, you must install:"
	elog "	gnome-extra/nautilus-gloobus-preview"
}
