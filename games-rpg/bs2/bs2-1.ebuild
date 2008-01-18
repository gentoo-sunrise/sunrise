# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

DESCRIPTION="Broken Sword 2: The Smoking Mirror"
HOMEPAGE="http://www.revolution.co.uk/_display.php?id=15"
SRC_URI="mirror://sourceforge/scummvm/Sword2_DXA_Cutscenes.zip
	http://gentooexperimental.org/~unlord/Sword2_DXA_Cutscenes.zip"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="strip"

RDEPEND=">=games-engines/scummvm-0.10.0"
DEPEND="app-arch/unzip"

S=${WORKDIR}
dir=${GAMES_DATADIR}/${PN}

src_install() {
	insinto "${dir}"

	cdrom_get_cds Clusters/Cluster.tab \
		Clusters/Carib1.clu

	einfo "Copying files from Disk 1..."
	doins ${CDROM_ROOT}/Clusters/Cluster.tab \
		${CDROM_ROOT}/Clusters/Docks.clu \
		${CDROM_ROOT}/Clusters/Font.clu \
		${CDROM_ROOT}/Clusters/General.clu \
		${CDROM_ROOT}/Clusters/Paris.clu \
		${CDROM_ROOT}/Clusters/Players.clu \
		${CDROM_ROOT}/Clusters/Quaramon.clu \
		${CDROM_ROOT}/Clusters/resource.inf \
		${CDROM_ROOT}/Clusters/resource.tab \
		${CDROM_ROOT}/Clusters/SCRIPTS.CLU \
		${CDROM_ROOT}/Clusters/Text.clu \
		${CDROM_ROOT}/Clusters/Warehous.clu \
		${CDROM_ROOT}/Sword2/cd.inf \
		${CDROM_ROOT}/Sword2/Startup.inf || die "doins failed"
	newins ${CDROM_ROOT}/Clusters/Music.clu Music1.clu || die "newins failed"
	newins ${CDROM_ROOT}/Clusters/speech.clu speech1.clu || die "newins failed"

	cdrom_load_next_cd
	einfo "Copying files from Disk 2..."
	doins ${CDROM_ROOT}/Clusters/Carib1.clu \
		${CDROM_ROOT}/Clusters/Carib2.clu \
		${CDROM_ROOT}/Clusters/Carib3.clu \
		${CDROM_ROOT}/Clusters/credits.bmp \
		${CDROM_ROOT}/Clusters/Credits.clu \
		${CDROM_ROOT}/Clusters/Font.clu \
		${CDROM_ROOT}/Clusters/Jungle.clu \
		${CDROM_ROOT}/Clusters/Pyramid1.clu \
		${CDROM_ROOT}/Clusters/Pyramid2.clu || die "doins failed"
	newins ${CDROM_ROOT}/Clusters/Music.clu Music2.clu || die "newins failed"
	newins ${CDROM_ROOT}/Clusters/speech.clu speech2.clu || die "newins failed"

	doins *.{dxa,fla} || die "doins failed"

	games_make_wrapper ${PN} "scummvm -f -p \"${dir}\" sword2"
	doicon "${FILESDIR}/${PN}.png" || die "doicon failed"
	make_desktop_entry ${PN} "Broken Sword 2" ${PN}.png

	prepgamesdirs
}
