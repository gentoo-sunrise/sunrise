# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_PV=446

DESCRIPTION="Decoder for onlinetvrecorder.com (German)"
HOMEPAGE="http://www.onlinetvrecorder.com/"
SRC_URI="http://www.onlinetvrecorder.com/downloads/${PN}-linux-v${MY_PV}.tar.bz2"
LICENSE="as-is"

SLOT="0"
KEYWORDS="~x86"

IUSE="X"

RDEPEND="X? ( gnome-base/libglade
		dev-python/pygtk )"
DEPEND=""

RESTRICT="strip"
S="${WORKDIR}/${PN}-linux-v${MY_PV}"

src_install() {
	dobin otrdecoder
	if use X; then
		insinto /usr/share/${P}
		doins decoder.glade

		sed -i -e "s:xml = gtk.glade.XML(join(decoderpath,'decoder.glade')):xml = gtk.glade.XML(join('/usr/share/${P}/','decoder.glade')):" \
			otrdecoder-gui
		dobin otrdecoder-gui
	fi

	dodoc README.OTR
}
