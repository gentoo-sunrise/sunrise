# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="Decoder for onlinetvrecorder.com (German)"
HOMEPAGE="http://www.onlinetvrecorder.com/"
SRC_URI="amd64? ( http://www.onlinetvrecorder.com/downloads/${PN}-linux-Ubuntu_8.04.2-x86_64-0.4.613.tar.bz2 )
	x86? ( http://www.onlinetvrecorder.com/downloads/${PN}-linux-Ubuntu_9.04-i686-0.4.${PV}.tar.bz2 )"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86 -*"
IUSE="X"

RDEPEND="X? ( gnome-base/libglade
		dev-python/pygtk )"

RESTRICT="strip"

src_unpack() {
	default
	mv ${PN}-linux-Ubuntu_* "${S}" || die
}

src_prepare() {
	sed -i -e "/xml/s:decoderpath:'/usr/share/${PN}':" otrdecoder-gui || die "sed failed"
}

src_install() {
	dobin otrdecoder || die "dobin failed"
	if use X; then
		insinto /usr/share/${PN}
		doins decoder.glade || die "doins failed"
		dobin otrdecoder-gui || die "dobin failed"
	fi

	dodoc README.OTR || die "dodoc failed"
}
