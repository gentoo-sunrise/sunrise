# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A GTK+2 tool to edit/create/transform/... subtitles for GNU/*."
HOMEPAGE="http://kitone.free.fr/subtitleeditor/"
SRC_URI="http://kitone.free.fr/${PN}/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.6
	>=dev-cpp/gtkmm-2.6
	>=dev-cpp/libglademm-2.4
	>=media-libs/gstreamer-0.10
	app-text/aspell"
RDEPEND="${DEPEND}"

src_install() {
	# Bug filed upstream
	sed -i -e "s:${PN}-icon:/usr/share/${PN}/${PN}:" "share/${PN}.desktop"
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS NEWS README TODO
}
