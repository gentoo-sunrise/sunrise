# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="CounterPath X-Lite - a free closed-source SIP Softphone Client for Linux"
HOMEPAGE="http://www.counterpath.net/index.php"
SRC_URI="http://www.counterpath.net/download/X-Lite_Install.tar.gz"

LICENSE="Freeware"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="strip"

RDEPEND="${DEPEND}
	dev-libs/atk
	dev-libs/glib
	dev-libs/libxml2
	gnome-base/libglade
	x11-libs/gtk+
	|| ( x11-libs/libX11 virtual/x11 )
	x11-libs/pango
	sys-libs/zlib
	amd64? ( >=app-emulation/emul-linux-x86-baselibs-2.4.1
		 >=app-emulation/emul-linux-x86-xlibs-2.2.2
		 >=app-emulation/emul-linux-x86-compat-1.0-r1
		 >=app-emulation/emul-linux-x86-gtklibs-2.3 )"

S=${WORKDIR}/xten-xlite

dir="/opt/x-lite"

pkg_setup() {
	has_multilib_profile && ABI="x86"
}

src_install() {
	exeinto "${dir}"
	doexe xtensoftphone

	dodir /opt/bin
	dosym /opt/x-lite/xtensoftphone /opt/bin/xtensoftphone

	make_desktop_entry xtensoftphone X-Lite
	doicon ${FILESDIR}/x-lite.png

	dodoc README
}

pkg_postinst() {
	einfo ""
	einfo "Warning:"
	einfo "this is still a beta release!"
	einfo "if you need support please browse counterpath's forums:"
	einfo "http://support.counterpath.com/"
	einfo ""
}
