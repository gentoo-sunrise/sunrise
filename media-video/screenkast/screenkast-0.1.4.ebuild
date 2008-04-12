# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

DESCRIPTION="Records your screen-activities, supports commentboxes and
exports to all video formats"
HOMEPAGE="http://screenkast.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=media-libs/libinstrudeo-${PV}
	x11-libs/libXt
	x11-libs/libXpm
	x11-libs/libXmu
	x11-libs/libXaw
	virtual/glut
	dev-cpp/glibmm
	>=dev-cpp/libxmlpp-2.6"
RDEPEND="${DEPEND}
	|| ( net-misc/tightvnc net-misc/vnc )"

need-kde 3.5

src_unpack() {
	kde_src_unpack
	sed -i -e "s/Version 0./Version=/" \
		-e "s/Qt;KDE;Video;;/Qt;KDE;Video;/" \
		-e "13d" \
		data/${PN}.desktop || die "sed failed"
}

src_install() {
	kde_src_install
	dodoc AUTHORS ChangeLog NEWS README TODO
}
