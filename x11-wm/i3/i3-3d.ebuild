# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit versionator multilib

MY_PV="$(get_major_version).$(get_version_component_range 2)"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="An improved dynamic tiling window manager"
HOMEPAGE="http://i3.zekjur.net/"
SRC_URI="http://i3.zekjur.net/downloads/${MY_P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=x11-libs/xcb-util-0.3.3
	>=x11-libs/libxcb-1.1.90.1
	x11-libs/libX11
	dev-libs/libev"
DEPEND="${RDEPEND}
	>=app-text/asciidoc-8.1.0
	>=x11-proto/xcb-proto-1.3"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -i \
		-e "s:DEBUG=1:DEBUG=0:" \
		-e "s:/usr/local/include:/usr/include:" \
		-e "s:/usr/local/lib:/usr/$(get_libdir):" \
		common.mk || die "sed die"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc GOALS TODO || die "dodoc ${PN} failed"
	doman man/*.1 || die "doman ${PN} failed"
}
