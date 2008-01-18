# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

DESCRIPTION="The Dig (interactive demo)"
HOMEPAGE="http://dig.mixnmojo.com/"
SRC_URI="http://gentooexperimental.org/~unlord/${PN}.rar"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="strip"

RDEPEND=">=games-engines/scummvm-0.8.2"
DEPEND="|| (
	app-arch/unrar
	app-arch/rar )"

S=${WORKDIR}/digdemo
dir=${GAMES_DATADIR}/${PN}

src_install() {
	insinto "${dir}"
	doins dig.la0 dig.la1 || die "doins failed"
	doins -r audio video || die "doins -r failed"

	games_make_wrapper ${PN} "scummvm -f -p \"${dir}\" dig"
	doicon "${FILESDIR}/${PN}.png" || die "doicon failed"
	make_desktop_entry ${PN} "The Dig (Demo)" ${PN}.png

	prepgamesdirs
}
