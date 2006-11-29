# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A GTK+2 tool to make and edit subtitles for GNU/*"
HOMEPAGE="http://kitone.free.fr/subtitleeditor/"

#MY_PV=`echo ${PV} | sed 's/_/-/g'` #QA: sed in global scope
MY_PV="${PV//_/-}"
MY_P="${PN}-${MY_PV}"
SRC_URI="http://kitone.free.fr/${PN}/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="cairo debug spell"

#pcre needs to support utf8; current version in portage forces it, fortunately
DEPEND=">=x11-libs/gtk+-2.6
>=dev-cpp/gtkmm-2.6
>=dev-cpp/libglademm-2.4
>=media-libs/gstreamer-0.10
dev-libs/libpcre
spell? ( >=app-text/enchant-1.1.0 )
cairo? ( x11-libs/cairo )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_compile() {
	econf \
		$(use_enable cairo) \
		$(use_enable debug) \
		$(use_enable spell enchant-support) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	#Bug filed upstream -- (which bug is it and what does it fix?)
	sed -i -e "s:${PN}-icon:/usr/share/${PN}/${PN}:" "share/${PN}.desktop"
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS NEWS README TODO
}

pkg_postinst() {
	if use cairo; then
		ewarn "cairo support is not finished, use at your own risk!"
	fi
}

