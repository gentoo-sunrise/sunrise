# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Utilities to change your default sound card in ALSA."
HOMEPAGE="https://code.launchpad.net/asoundconf-ui"

MY_P="alsa-utils_${PV}-1ubuntu4_i386"
GTK_PN="${PN}-gtk"
GTK_PV="1.5.1"
GTK_MY_P="${PN}-gtk_${GTK_PV}-0ubuntu2_all"
SRC_URI="mirror://ubuntu/pool/main/a/alsa-utils/${MY_P}.deb
	 gtk? ( mirror://ubuntu/pool/universe/a/${GTK_PN}/${GTK_MY_P}.deb )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="gtk"

RDEPEND="virtual/python
	>=media-sound/alsa-utils-1.0.14
	gtk? ( dev-python/pygtk
		x11-themes/gnome-icon-theme )" # needed for .desktop file

S="${WORKDIR}"

src_unpack() {
	unpack ${MY_P}.deb
	unpack ./data.tar.gz
	rm -f "${WORKDIR}"/{{control,data}.tar.gz,debian-binary}
	if use gtk ; then
		mkdir gtk
		pushd gtk
		unpack ${GTK_MY_P}.deb
		unpack ./data.tar.gz
		rm -f "${WORKDIR}"/gtk/{{control,data}.tar.gz,debian-binary}
		popd
	fi
}

src_install() {
	dobin usr/bin/asoundconf
	doman usr/share/man/man1/asoundconf.1.gz

	if use gtk ; then
		cd gtk
		dobin usr/bin/asoundconf-gtk
		doman usr/share/man/man8/asoundconf-gtk.8.gz
		dodoc usr/share/doc/${GTK_PN}/README
		domenu usr/share/applications/asoundconf-gtk.desktop
	fi
}
