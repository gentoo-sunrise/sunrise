# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit eutils games

# define own package name
MY_PN="PenumbraCollection"

DESCRIPTION="Scary first-person adventure game trilogy which focuses on story, immersion and puzzles"
HOMEPAGE="http://www.penumbragame.com/"
SRC_URI="${MY_PN}-${PV}.sh"

LICENSE="PENUMBRA-COLLECTION"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
PROPERTIES="interactive"
RESTRICT="fetch strip"

DEPEND="|| ( app-arch/xz-utils app-arch/lzma-utils )"
RDEPEND="virtual/opengl
	x86? (
		x11-libs/libXft
		media-libs/freealut
		media-gfx/nvidia-cg-toolkit
		x11-libs/fltk:1.1
		media-libs/sdl-image
		media-libs/sdl-ttf
		media-libs/libvorbis )
	amd64? (
		app-emulation/emul-linux-x86-sdl )"

GAMES_CHECK_LICENSE="yes"
dir=${GAMES_PREFIX_OPT}/${MY_PN}
INSTALL_KEY_FILE=${dir}/collectionkey

S=${WORKDIR}/${MY_PN}

pkg_nofetch() {
	einfo "Please buy & download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to ${DISTDIR}"
	einfo
}

src_unpack() {
	unpack_makeself || die "unpack installator"

	# give proper extension to install archive so unpack recognizes it
	mv instarchive_all instarchive_all.tar.lzma || \
		die "rename instarchive_all"

	unpack ./instarchive_all.tar.lzma || die "unpack install archive"
}

src_install() {

	# perform instalation for each episode; note that Requiem is extension of
	# Black Plague so it has no dedicated directory at this level
	for episodeDir in Overture BlackPlague; do

		# install game data files
		insinto "${dir}/${episodeDir}"

		# >install every directory recursively except lib
		for directory in \
			$(find ${episodeDir}/* -maxdepth 0 -type d ! -name lib); do
			doins -r ${directory} || die "doins game data files"
		done

		# >install .cfg files
		doins ${episodeDir}/*.cfg || die "doins .cfg files"

		# install libraries and executables
		exeinto "${dir}/${episodeDir}"
		doexe ${episodeDir}/openurl.sh ${episodeDir}/*.bin || \
			die "doexe binaries"

		# >amd64 does not provide some libs, use bundled ones
		if use amd64 ; then
			exeinto "${dir}/${episodeDir}/lib"
			for library in \
				libfltk.so.1.1 \
				libopenal.so.1.3.253 \
				libCgGL.so \
				libCg.so; do
				doexe ${episodeDir}/lib/${library} || die "doexe libraries"
			done
			dosym libopenal.so.1.3.253 "${dir}/${episodeDir}/lib/libopenal.so.1"
		fi

	done

	# install icons
	newicon Overture/penumbra.png penumbra-overture.png || \
		die "newicon overture"
	newicon BlackPlague/penumbra.png penumbra-blackplague.png || \
		die "newicon black plague"
	newicon BlackPlague/requiem.png penumbra-requiem.png || \
		die "newicon requiem"

	# make game wrappers
	games_make_wrapper penumbra-overture ./penumbra.bin \
		"${dir}/Overture" "${dir}/Overture/lib" || \
		die "games_make_wrapper overture"
	games_make_wrapper penumbra-blackplague ./blackplague.bin \
		"${dir}/BlackPlague" "${dir}/BlackPlague/lib" || \
		die "games_make_wrapper black plague"
	games_make_wrapper penumbra-requiem ./requiem.bin \
		"${dir}/BlackPlague" "${dir}/BlackPlague/lib" || \
		die "games_make_wrapper requiem"

	# make desktop entries
	make_desktop_entry penumbra-overture "Penumbra: Overture" \
		penumbra-overture || die "make_desktop_entry overture"
	make_desktop_entry penumbra-blackplague "Penumbra: Black Plague" \
		penumbra-blackplague || die "make_desktop_entry black plague"
	make_desktop_entry penumbra-requiem "Penumbra: Requiem" \
		penumbra-requiem || die "make_desktop_entry requiem"

	# install documentation
	docinto Overture
	dodoc Overture/CHANGELOG.txt Overture/Manual.pdf Overture/README.linux || \
		die "dodoc overture"
	docinto BlackPlague
	dodoc BlackPlague/Manual.pdf BlackPlague/README.linux || \
		die "dodoc black plague"

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	if [[ -f "${INSTALL_KEY_FILE}" ]] ; then
		einfo "The installation key file already exists: ${INSTALL_KEY_FILE}"
	else
		ewarn "You MUST run this before playing the game:"
		ewarn "  emerge --config ${PN}"
		ewarn "To enter your installation key."
	fi
}

pkg_config() {
	local key1 key2

	ewarn "Your installation key is NOT checked for validity here."
	ewarn "Make sure you type it in correctly."
	ewarn "If you CTRL+C out of this, the game will not run!"
	echo
	einfo "The key format is: XXXX-XXXX-XXXX-XXXX"
	while true ; do
		einfo "Please enter your key:"
		read key1
		if [[ -z "${key1}" ]] ; then
			echo "You entered a blank key. Try again."
			continue
		fi
		einfo "Please re-enter your key:"
		read key2
		if [[ -z "${key2}" ]] ; then
			echo "You entered a blank key. Try again."
			continue
		fi

		if [[ "${key1}" == "${key2}" ]] ; then
			echo "${key1}" | tr a-z A-Z > "${INSTALL_KEY_FILE}"
			echo -e "// Do not give this file to ANYONE.\n// Frictional Games Support will NEVER ask for this file" \
				>> "${INSTALL_KEY_FILE}"
			einfo "Thanks, created ${INSTALL_KEY_FILE}"
			break
		else
			eerror "Your installation key entries do not match. Try again."
		fi
	done
}
