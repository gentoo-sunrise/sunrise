# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games

DESCRIPTION="Tactics Squad is a real-time tactical game set in a futuristic environment."
HOMEPAGE="http://sourceforge.net/projects/tacticsgame/"
SRC_URI="mirror://sourceforge/${PN}/Tactics_Squad_${PV}_Linux.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="media-libs/libsdl
	virtual/opengl"
RDEPEND="${DEPEND}"

S="${WORKDIR}/TS"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e "s:-O3:${CXXFLAGS}:" Makefile || die "Sed Makefile failed"
}

src_install() {
	dogamesbin Tactics || die "Install Failed"
	newdoc "Change Log.txt" ChangeLog.txt || die "Doc install failed"
	newdoc "Release Notes.txt" ReleaseNotes.txt || die "Doc install failed"
	prepgamesdirs
	prepalldocs
}
