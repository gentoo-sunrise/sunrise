# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit autotools

DESCRIPTION="Plugins for UCView image capture application"
HOMEPAGE="http://unicap-imaging.org/"
SRC_URI="http://unicap-imaging.org/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

DEPEND=">=media-video/ucview-0.30
	x11-libs/gtk+:2
	nls? ( virtual/libintl )"
RDEPEND=${DEPEND}

src_prepare() {
	mkdir -p ucview_{debayer,histogram,videoplay}_plugin/m4
	eautoreconf
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README || die

	# remove stray empty dir
	rmdir "${D}"/usr/share/ucview{/glade,}
}
