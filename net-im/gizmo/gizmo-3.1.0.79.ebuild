# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P=gizmo-project-${PV}

DESCRIPTION="A P2P-VoiceIP client"
HOMEPAGE="http://www.gizmoproject.com/"
SRC_URI="http://download.gizmoproject.com/jasmine/gtk-${P}/${MY_P}-1-libstdc++6.tar.gz"

LICENSE="gizmoproject-eula"
SLOT="0"
KEYWORDS="~x86"
IUSE="avahi"

RESTRICT="mirror strip"

RDEPEND="dev-libs/atk
	>=gnome-base/gconf-2
	media-libs/alsa-lib
	>=x11-libs/gtk+-2.6
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/pango
	sys-libs/zlib
	avahi? ( || ( net-dns/avahi net-misc/mDNSResponder ) )"

S=${WORKDIR}/${MY_P}

src_install() {
	insinto /opt
	doins -r share/gizmo
	exeinto /opt/gizmo
	doexe gizmo libsipphoneapi.s*
	sed -i -e "s:CURDIR=.*:CURDIR=/opt/gizmo:" -e "s:share/gizmo::" gizmo-run
	exeinto /opt/bin
	newexe gizmo-run gizmo

	dodoc ChangeLog README.TXT

	newicon share/gizmo/pixmaps/icons/gizmo-icon-48.png ${PN}.png
	make_desktop_entry ${PN} "Gizmo Project" ${PN}.png "Network;Telephony;P2P"
}
