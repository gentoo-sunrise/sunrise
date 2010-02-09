# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit games

DESCRIPTION="INSTEAD quest engine"
HOMEPAGE="http://instead.googlecode.com/"
SRC_URI="http://instead.googlecode.com/files/${P/-/_}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="=dev-lang/lua-5.1*
	media-libs/libsdl
	media-libs/sdl-mixer
	media-libs/sdl-image
	media-libs/sdl-ttf"
RDEPEND="${DEPEND}"

src_prepare() {
	cp Rules.make.system Rules.make || die "Cannot copy Rules.make.system"
	sed -i Rules.make \
		-e 's/lua5.1/lua/' \
		-e 's:PREFIX=.*:PREFIX=/usr:' \
		-e 's:BIN=.*:BIN=$(DESTDIR)'"${GAMES_BINDIR}:" \
		-e 's:STEADPATH=$(DESTDIR)$(PREFIX)/share:STEADPATH=$(DESTDIR)'"${GAMES_DATADIR}:" \
		-e 's:DOCPATH=$(DESTDIR)$(PREFIX)/share:DOCPATH=$(DESTDIR)'"${GAMES_DATADIR}:" || die "Cannot patch Rules.make"
}

src_install() {
	emake DESTDIR="${D}"  install || die "emake install failed"
	prepgamesdirs
}
