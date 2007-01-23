# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_PV="${PV//_/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="A GTK+ subtitle editing tool"
HOMEPAGE="http://kitone.free.fr/subtitleeditor/"
SRC_URI="http://kitone.free.fr/${PN}/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cairo debug spell"

# pcre needs to support utf8; current version in portage forces it, fortunately
DEPEND=">=dev-cpp/gtkmm-2.6
	>=dev-cpp/libglademm-2.4
	dev-libs/libpcre
	>=media-libs/gstreamer-0.10
	>=x11-libs/gtk+-2.6
	cairo? ( x11-libs/cairo )
	spell? ( >=app-text/enchant-1.1.0 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_compile() {
	export GST_REGISTRY="${T}/home/registry.cache.xml"
	addpredict "${ROOT}/root/.gconf"
	addpredict "${ROOT}/root/.gconfd"
	econf \
		$(use_enable cairo) \
		$(use_enable debug) \
		$(use_enable spell enchant-support) \
		|| die "configure failed"
	emake || die "make failed"
}

src_install() {
	# Bug filed upstream -- (which bug is it and what does it fix?)
	sed -i -e "s:${PN}-icon:/usr/share/${PN}/${PN}:" "share/${PN}.desktop"
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS NEWS README TODO
}

pkg_postinst() {
	use cairo && ewarn "Cairo support is not finished -- use at your own risk!"
}
