# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games

DESCRIPTION="A 3D Fantasy MMORPG"
HOMEPAGE="http://planeshift.it"
SRC_URI="x86? ( mirror://planeshift/PlaneShift-v${PV}-x86.bin )
	amd64? ( mirror://planeshift/PlaneShift-v${PV}-x64.bin )"

LICENSE="GPL-3 PlaneShift"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RESTRICT="strip"

src_unpack() {
	cp -L "${DISTDIR}/${A}" "${WORKDIR}" || die "Copy ${A} to ${WORKDIR}"
	chmod +x "${WORKDIR}/${A}" || die "chmod die"
}

src_install() {
	"${WORKDIR}"/${A} \
		--mode unattended \
		--perms yes \
		--usergroup games \
		--prefix "${D}/${GAMES_PREFIX_OPT}" || die "Installer of Planeshift die"

	rm "${D}/${GAMES_PREFIX_OPT}"/PlaneShift/psupdater
	rm "${D}/${GAMES_PREFIX_OPT}"/PlaneShift/psupdater.bin
	rm "${D}/${GAMES_PREFIX_OPT}"/PlaneShift/uninstall

	games_make_wrapper psclient "${GAMES_PREFIX_OPT}/PlaneShift/psclient"
	make_desktop_entry psclient "Play PlaneShift"

	games_make_wrapper pssetup "${GAMES_PREFIX_OPT}/PlaneShift/pssetup"
	make_desktop_entry pssetup "PlaneShift setup"
}
