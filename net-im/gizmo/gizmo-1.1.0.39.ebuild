# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P=gizmo-project-${PV}

DESCRIPTION="Gizmo is a P2P-VoiceIP client"
HOMEPAGE="http://www.gizmoproject.com/"
SRC_URI="http://download.gizmoproject.com/GizmoDownload/${MY_P}.tar.gz"
LICENSE="gizmoproject-eula"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RESTRICT="mirror strip"

RDEPEND="dev-libs/atk
	>=gnome-base/gconf-2
	media-libs/alsa-lib
	>=x11-libs/gtk+-2.6
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/pango
	sys-libs/zlib"

S=${WORKDIR}/${MY_P}

src_install() {
	insinto /opt/gizmo
	doins -r share
	exeinto /opt/gizmo
	doexe gizmo{,-run} libsipphoneapi.so{,.1.5.06}


	dodoc ChangeLog README.TXT

	make_wrapper ${PN} ./${PN}-run /opt/${PN} . || die "make_wrapper failed"
	doicon share/gizmo/pixmaps/icons/gizmo-icon-48.png
	make_desktop_entry ${PN} "Gizmo Project" gizmo-icon-48.png
}
