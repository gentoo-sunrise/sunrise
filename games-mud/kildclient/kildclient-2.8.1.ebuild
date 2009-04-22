# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit games

DESCRIPTION="Powerful MUD client with a built-in PERL interpreter"
HOMEPAGE="http://kildclient.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc gnutls spell"

DEPEND="x11-libs/gtk+:2
	spell? ( app-text/gtkspell )
	gnutls? ( net-libs/gnutls )"
RDEPEND="${DEPEND}"

src_configure() {
	egamesconf \
		$(use_with spell gtkspell) \
		$(use_with gnutls) \
		$(use_with doc)
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	prepgamesdirs
}
