# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils qt4

DESCRIPTION="A cosmic recursive flame fractal editor written in Qt"
HOMEPAGE="http://qosmic.googlecode.com"
SRC_URI="${HOMEPAGE}/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples linguas_fr"

RDEPEND="dev-lang/lua
	>=media-gfx/flam3-2.7.18
	>=x11-libs/qt-gui-4.5"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	sed -i -e 's:^SHARED =.*:SHARED = /usr/share/qosmic:' qosmic.pro || die "sed failed"
}

src_configure() {
	eqmake4
}

src_install() {
	dodoc README README-LUA || die "dodoc failed"
	dobin qosmic || die "dobin failed"
	doicon icons/qosmicicon.xpm || die "doicon failed"
	make_desktop_entry qosmic "Qosmic" qosmicicon.xpm "KDE;Qt;Graphics"

	if use examples ; then
		docinto examples
		dodoc scripts/* || die "dodoc failed"
	fi

	if use linguas_fr ; then
		insinto /usr/share/qosmic/translations
		doins ts/qosmic_fr.qm || die "doins failed"
	fi
}
