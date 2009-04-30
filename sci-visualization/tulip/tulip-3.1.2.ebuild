# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit autotools multilib

DESCRIPTION="Large Graph Visualization System"
HOMEPAGE="http://tulip.labri.fr/"
SRC_URI="mirror://sourceforge/auber/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="stats tlprender"

RDEPEND="dev-libs/libxml2
	media-libs/freetype:2
	media-libs/glew
	x11-libs/qt-assistant:4
	x11-libs/qt-gui:4
	x11-libs/qt-opengl:4"
DEPEND="${RDEPEND}"

pkg_setup() {
	enewgroup tulip
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	eautoreconf
}

src_compile() {
	econf	$(use_enable tlprender) \
		$(use_enable stats stat-gui) \
		"--with-qt-includes=/usr/include/qt4" \
		"--with-qt-libraries=/usr/$(get_libdir)/qt4" \
		"MOC=/usr/bin/moc UIC=/usr/bin/uic"
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	rm -r "${D}/usr/share/tulip"
	dodoc TODO README AUTHORS ChangeLog || die "dodoc failed"
}

