# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

DESCRIPTION="Broken Sword 1: The Shadow of the Templars"
HOMEPAGE="http://www.revolution.co.uk/_display.php?id=14"
SRC_URI="mirror://sourceforge/scummvm/Sword1_DXA_Cutscenes.zip
	http://gentooexperimental.org/~unlord/Sword1_DXA_Cutscenes.zip"

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

	cdrom_get_cds CD1.ID CD2.ID

	einfo "Copying files from Disk 1..."
	doins ${CDROM_ROOT}/CLUSTERS/COMPACTS.CLU \
		${CDROM_ROOT}/CLUSTERS/GENERAL.CLU \
		${CDROM_ROOT}/CLUSTERS/MAPS.CLU \
		${CDROM_ROOT}/CLUSTERS/PARIS1.CLU \
		${CDROM_ROOT}/CLUSTERS/PARIS2.CLU \
		${CDROM_ROOT}/CLUSTERS/PARIS3.CLU \
		${CDROM_ROOT}/CLUSTERS/PARIS4.CLU \
		${CDROM_ROOT}/CLUSTERS/SCRIPTS.CLU \
		${CDROM_ROOT}/CLUSTERS/SWORDRES.RIF \
		${CDROM_ROOT}/CLUSTERS/TEXT.CLU || die "doins failed"
	doins -r ${CDROM_ROOT}/MUSIC || die "doins -r failed"
	newins ${CDROM_ROOT}/SPEECH/SPEECH.CLU SPEECH1.CLU || die "newins failed"

	cdrom_load_next_cd
	einfo "Copying files from Disk 2..."
	doins ${CDROM_ROOT}/CLUSTERS/IRELAND.CLU \
		${CDROM_ROOT}/CLUSTERS/SCOTLAND.CLU \
		${CDROM_ROOT}/CLUSTERS/SPAIN.CLU \
		${CDROM_ROOT}/CLUSTERS/SYRIA.CLU \
		${CDROM_ROOT}/CLUSTERS/TRAIN.CLU || die "doins failed"
	doins -r ${CDROM_ROOT}/MUSIC || die "doins -r failed"
	newins ${CDROM_ROOT}/SPEECH/SPEECH.CLU SPEECH2.CLU || die "newins failed"

	doins *.{dxa,fla} || die "doins failed"

	games_make_wrapper ${PN} "scummvm -f -p \"${dir}\" sword1"
	doicon "${FILESDIR}/${PN}.png" || die "doicon failed"
	make_desktop_entry ${PN} "Broken Sword 1" ${PN}.png

	prepgamesdirs
}
