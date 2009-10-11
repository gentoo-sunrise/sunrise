# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils multilib rpm

DESCRIPTION="Hulu desktop"
HOMEPAGE="http://www.hulu.com/labs/hulu-desktop-linux"
SRC_URI="amd64? ( http://download.hulu.com/${PN}.x86_64.rpm -> ${P}.x86_64.rpm )
		x86? ( http://download.hulu.com/${PN}.i386.rpm -> ${P}.i386.rpm )"

LICENSE="Hulu-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="www-plugins/adobe-flash
		x11-libs/gtk+:2
		dev-libs/glib"

src_install() {
	insinto /etc/${PN}
	doins etc/${PN}/hd_keymap.ini || die "Failed doins"

	dobin usr/bin/${PN} || die "Failed dobin"

	domenu usr/share/applications/${PN}.desktop || die "Failed domenu"
	doicon usr/share/pixmaps/${PN}.png || die "Failed doicon"
	dodoc usr/share/doc/${PN}/README || die "Failed dodoc"
}

pkg_postinst() {
	einfo "This program can utilize a remote control.  Please install"
	einfo "app-misc/lirc if you wish to use a remote with ${PN}."
	einfo
	ewarn "The file ~/.${PN} should be created for you if you start Hulu Desktop"
	ewarn "but the path to the flash plugin is not set by default."
	ewarn
	ewarn "You need to add the following to ~/.${PN}:"
	ewarn "[flash]"
	ewarn "flash_location = /usr/$(get_libdir)/nsbrowser/plugins/libflashplayer.so"
}
