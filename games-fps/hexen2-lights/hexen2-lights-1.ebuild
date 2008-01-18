# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

MY_PN="hexen2"

DESCRIPTION="Colored lighting data for Hexen 2"
HOMEPAGE="http://uhexen2.sourceforge.net/"
SRC_URI="mirror://sourceforge/uhexen2/hexen2-lit_files.tgz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=""

S=${WORKDIR}
dir=${GAMES_DATADIR}/${MY_PN}

src_install() {
	insinto "${dir}"
	doins -r data1 || die "doins * failed"

	# The 3 demo maps are also in the demo data.
	dodir "${dir}"/demo/data1/maps
	local i
	for i in 1 2 3 ; do
		dosym "${dir}"/data1/maps/demo${i}.lit  "${dir}"/demo/data1/maps
	done

	dodoc *.txt

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	if ! has_version "games-fps/uhexen2" ; then
		einfo "This is just lighting data. To play, emerge a client"
		einfo "such as uhexen2."
		echo
	fi
}
