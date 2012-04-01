# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools eutils linux-info

DESCRIPTION="Configuration GUI for Belkin Nostromo n50/n52 speedpads."
HOMEPAGE="http://sf.net/projects/nostromodriver/"
SRC_URI="mirror://sourceforge/nostromodriver/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	x11-libs/libXft
	x11-libs/libXtst
	dev-libs/libxml2
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-libs/fltk:1
	x11-proto/xextproto"

CONFIG_CHECK="INPUT_EVDEV"

src_prepare() {
	epatch "${FILESDIR}"/${P}-asneeded.patch
	eautoreconf
}

src_install() {
	default
	dohtml doc/*
	insinto /etc/udev/rules.d
	doins "${FILESDIR}/60-nostromo.rules"

	make_desktop_entry nostromo_config "Nostromo Configuration" /usr/share/pixmaps/n50_tray.png "System"
	make_desktop_entry nostromo_daemon "Nostromo Daemon" /usr/share/pixmaps/n50_tray.png "System"
}
