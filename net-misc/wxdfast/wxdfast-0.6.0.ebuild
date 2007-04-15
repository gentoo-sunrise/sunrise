# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils wxwidgets

DESCRIPTION="Multithreaded download manager (also known as wxDownload Fast)"
HOMEPAGE="http://dfast.sourceforge.net/"
SRC_URI="mirror://sourceforge/dfast/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND=">=x11-libs/wxGTK-2.6"
RDEPEND="${DEPEND}"

src_compile() {
	WX_GTK_VER=2.6
	need-wxwidgets unicode || die "please rebuild wxGTK with unicode useflag"

	#we had to pass the "wx-config" because sometimes it won't work otherwise
	econf $(use_enable debug) --with-wx-config="wx-config" || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	doicon resources/RipStop/icon/wxdfast.png
	#the makefile creates the appropriate desktop entry

	dodoc AUTHORS ChangeLog README TODO
}
