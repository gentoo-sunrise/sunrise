# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils

DESCRIPTION="A standalone skill monitoring application for EVE Online"
HOMEPAGE="http://gtkevemon.battleclinic.com"
SRC_URI="http://gtkevemon.battleclinic.com/releases/${P}-source.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-cpp/gtkmm:2.4
	dev-libs/libxml2"
DEPEND="${DEPEND}
	dev-util/pkgconfig"

src_prepare() {
	sed -e 's:Categories=Game;$:Categories=Game;RolePlaying;GTK;:' \
		-i icon/${PN}.desktop || die "sed failed"
	# upstream fix for new character portrait URL
	epatch "${FILESDIR}/${P}-portrait.patch"
	# upstream fix for remap calculation after learning skills removal
	epatch "${FILESDIR}/${P}-learning.patch.gz"
}

src_install() {
	dobin src/${PN} || die "dobin failed"
	dodoc CHANGES README TODO || die "dodoc failed"
	cd icon
	doicon ${PN}.xpm || die "doicon failed"
	domenu ${PN}.desktop || die "domenu failed"
}
