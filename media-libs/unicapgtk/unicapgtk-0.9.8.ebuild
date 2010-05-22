# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="GTK2 widget for the unicap video capture library"
HOMEPAGE="http://unicap-imaging.org/"
SRC_URI="http://unicap-imaging.org/downloads/lib${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc nls"

RDEPEND="~media-libs/unicap-${PV}
	x11-libs/gtk+:2
	x11-libs/libXv
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc )"

S=${WORKDIR}/lib${P}

src_configure() {
	econf \
		$(use_enable debug debug-unicapgtk) \
		$(use_enable doc gtk-doc) \
		$(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README || die
}
