# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="${PN}-3.a"

DESCRIPTION="An improved dynamic tiling window manager"
HOMEPAGE="http://i3.zekjur.net/"
SRC_URI="http://i3.zekjur.net/downloads/${MY_P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="~x11-libs/xcb-util-0.3.3
	>=x11-libs/libxcb-1.1.90.1
	x11-libs/libX11"
DEPEND="${RDEPEND}
	app-text/asciidoc"

S="${WORKDIR}/${MY_P}"

src_compile() {
	emake || die "emake failed"
	emake -C man || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc GOALS TODO || die "dodoc ${PN} failed"

	doman man/${PN}.1 || die "doman ${PN} failed"

	echo -e "#!/bin/sh\n/usr/bin/${PN}" > "${T}/${PN}"
	exeinto /etc/X11/Sessions
	doexe "${T}/${PN}" || die "doexe ${PN} failes"
}
