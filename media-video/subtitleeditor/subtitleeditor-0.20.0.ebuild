# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

MY_PVM="$(get_version_component_range 1-2)"
DESCRIPTION="A GTK+ subtitle editing tool"
HOMEPAGE="http://home.gna.org/subtitleeditor/"
SRC_URI="http://download.gna.org/${PN}/${MY_PVM}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cairo debug spell"

DEPEND=">=dev-cpp/libxmlpp-2.10.0
	>=dev-cpp/gtkmm-2.6
	>=dev-cpp/libglademm-2.4
	dev-libs/libpcre
	>=media-libs/gstreamer-0.10
	>=media-libs/gst-plugins-good-0.10
	>=x11-libs/gtk+-2.6
	cairo? ( x11-libs/cairo )
	spell? ( >=app-text/enchant-1.1.0 )"
RDEPEND="${DEPEND}
	>=media-plugins/gst-plugins-ffmpeg-0.10"

pkg_setup() {
	if ! built_with_use dev-libs/libpcre unicode ; then
		eerror "${PN} requires dev-libs/libpcre with unicode support"
		die "Recompile dev-libs/libpcre with USE=\"unicode\" first."
	fi
}

src_compile() {
	export GST_REGISTRY="${T}/home/registry.cache.xml"
	addpredict "${ROOT}root/.gconf"
	addpredict "${ROOT}root/.gconfd"
	econf \
		$(use_enable cairo) \
		$(use_enable debug) \
		$(use_enable spell enchant-support) \
		|| die "configure failed"
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS NEWS README TODO
}

pkg_postinst() {
	use cairo && ewarn "Cairo support is not finished -- use at your own risk!"
}
