# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="CounterPath X-Lite - a free closed-source SIP Softphone Client for Linux"
HOMEPAGE="http://www.counterpath.net/index.php"
SRC_URI="http://www.counterpath.net/download/X-Lite_Install.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RESTRICT="strip"

RDEPEND="dev-libs/atk
	dev-libs/glib
	dev-libs/libxml2
	gnome-base/libglade
	=x11-libs/gtk+-2*
	x11-libs/pango
	x11-libs/cairo
	sys-libs/zlib
	media-libs/libpng
	=media-libs/freetype-2*
	x11-libs/libX11
	x11-libs/libXfixes
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXcursor
	x11-libs/libXft
	x11-libs/libXau
	x11-libs/libXdmcp
	=virtual/libstdc++-3.3"

S=${WORKDIR}/xten-xlite

pkg_setup() {
	has_multilib_profile && ABI="x86"
}

src_install() {
	local dir="/opt/x-lite"
	exeinto "${dir}"
	doexe xtensoftphone

	dodir /opt/bin
	dosym ${dir}/xtensoftphone /opt/bin/xtensoftphone

	doicon "${FILESDIR}/x-lite.png"
	make_desktop_entry xtensoftphone X-Lite ${PN}.png "Network;Telephony"

	dodoc README
}

pkg_postinst() {
	elog
	elog "Warning: this is still a beta release!"
	elog "If you need support please browse counterpath's forums:"
	elog "http://support.counterpath.com/"
	elog
}
