# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit eutils games

OFFICIAL_PATCH="moo2v131.zip"
LB_PATCH="Moo2v140b24.zip"

DESCRIPTION="A classic 4X turn-based space strategy game"
HOMEPAGE="http://lordbrazen.blogspot.com"
SRC_URI="ftp://ftp.infogrames.net/patches/moo2/${OFFICIAL_PATCH}
	lordbrazen? ( http://www.spheriumnorth.com/blog-images/${LB_PATCH} )"

LICENSE="GPL-2 MicroProse-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nocd lordbrazen"

DEPEND="|| ( media-gfx/graphicsmagick media-gfx/imagemagick )"
RDEPEND="games-emulation/dosbox"

GAMES_CHECK_LICENSE="yes"
destDir="${GAMES_PREFIX_OPT}/${PN}"

pkg_setup() {
	games_pkg_setup
	cdrom_get_cds ORION2.EXE
	test -e "${CDROM_ROOT}/ORION2.EXE" ||
		die "CD_ROOT does not point to the Master of Orion 2 CD"
}

src_unpack() {
	cd "${WORKDIR}"
	sed "s:__MOO2DIR__:${destDir}:g" "${FILESDIR}/${PVR}/moo2" > moo2 ||
		die "sed failed"

	# Copy CD or create symlink
	if use nocd; then
		# ebuild complains about directx drivers :(
		#tar cC "${CDROM_ROOT}" . | tar xC cd || die
		mkdir -p cd  || die
		pushd "${CDROM_ROOT}" > /dev/null || die
		einfo "Copying CD-ROM..."
		tar c $(ls -1 | egrep -v 'DIRECTX') | tar xC "${WORKDIR}/cd" ||
			die "Failed to copy CD-ROM data from ${CDROM_ROOT} to ${WORKDIR}/cd"
		popd > /dev/null
	else
		ln -s "${CDROM_ROOT}" "${WORKDIR}/cd"
	fi

	# Now we do everything that the normal DOS-based setup program does.
	mkdir -p MPS/ORION2 || die
	pushd MPS/ORION2 > /dev/null || die

	# If nocd is specified, we'll take care of this in src_install
	if ! use nocd; then
		tar cC "${WORKDIR}/cd" $(cat "${FILESDIR}/installList.txt") |
			tar x || die
	fi

	# Apply official 1.31 patch (will overwrite some symlinks if USE=nocd, but
	# that's OK).
	unpack ${OFFICIAL_PATCH}

	# Install pre-configured .INI files (hardware is simulated, so it's all the
	# same)
	cp -L "${FILESDIR}/"*.INI . || die

	# Add unofficial patch if use flag set, although it has to be run in dosbox,
	# so it will actually run the first time the user lanuches the game.
	if use lordbrazen; then
		unpack ${LB_PATCH} || die
	fi
	popd > /dev/null

	# Convert m$ ico to png
	convert "${WORKDIR}/cd/ORION2.ICO" "${WORKDIR}/${PN}.png" ||
		die "convert failed"
}

src_install() {
	dogamesbin "${WORKDIR}/moo2" || die

	insinto "${destDir}"
	doins -r MPS || die "doins failed"
	doins "${FILESDIR}/${PVR}/"{moo2rc,utils.sh,backup.sh} ||
		die "doins failed"

	if use nocd; then
		# Copy the CD to disk
		doins -r cd || die "doins failed"

		# If copying the entire CD to the hard drive anyway, we'll just use hard
		# links to for the game install (what the DOS-based setup program
		# normally does) except, of course, we wont overwrite files that have
		# been replaced by a patch.
		for f in $(cat "${FILESDIR}/installList.txt"); do
			local src="${destDir}/cd/$f"
			local dest="${destDir}/MPS/ORION2/$f"
			if [[ ! -e "${WORKDIR}/MPS/ORION2/$f" ]]; then
				dosym "${src}" "${dest}" || die "dosym ${src} ${dest} failed"
			fi
		done
	else
		# Create symlink to the CD.  If the user has more than one CD-ROM drive
		# or mount point, this can break later, but they can just re-install or
		# fix it themselves.
		dosym "${CDROM_ROOT}" "${destDir}/cd" || die
	fi

	doicon "${WORKDIR}/${PN}.png" || die "doicon failed"
	make_desktop_entry "${PN}" "Master of Orion II: Battle at Antares" ||
		die "make_desktop_entry failed"
	prepgamesdirs
}

# vim:ts=4