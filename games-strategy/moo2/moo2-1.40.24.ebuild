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

LICENSE="GPL-2 Hasbro-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nocd lordbrazen"

DEPEND="|| ( media-gfx/graphicsmagick media-gfx/imagemagick )"
RDEPEND="games-emulation/dosbox"

destDir="${GAMES_PREFIX_OPT}/${PN}"
fullGameName="Master of Orion II: Battle at Antares"
unsupportedMsg="
Unfortunately, several differing versions of the Master of Orion II: Battle at
Antares CD-ROM have been released and this ebuild does not have specific
support yours and may fail. Please help out!  Visit
http://bugs.gentoo.org/show_bug.cgi?id=341859 and post the result of this
ebuild along with a full directory listing of your CD-ROM, the contents of the
the README.TXT file and any other info you think might be helpful.
"

pkg_setup() {
	games_pkg_setup
	cdrom_get_cds ORION95.EXE

	# Workaround to bug #342269
	test -e "${CDROM_ROOT}/ORION95.EXE" ||
		die "CD_ROOT does not point to the ${fullGameName} CD"

	# Try to determine Which version of the CD-ROM we have.  These tests are
	# far from perfect, but will work on the two currently known versions.
	if [[ -e "${CDROM_ROOT}/Patch13.lbx" ]]; then
		# Hasboro v1.31 minus DOS support
		cdVersion=H1.31
	elif [[ -e "${CDROM_ROOT}/INSTALL.EXE" ]]; then
		# Original MicroProse v1.2
		cdVersion=M1.2
	else
		# There may be others out there
		cdVersion=unknown
		ewarn "${unsupportedMsg}"
	fi
}

src_unpack() {
	local srcIcon

	sed "s:__MOO2DIR__:${destDir}:g" "${FILESDIR}/${PVR}/moo2" > moo2 ||
		die "sed failed"

	mkdir -p patches docs || die
	pushd patches || die

	# First, unpack the MicroProse official 1.31 patch
	unpack ${OFFICIAL_PATCH} || die

	# Add unofficial patch if use flag set, although it has to be run in dosbox,
	# so it will actually run the first time the user lanuches the game.
	if use lordbrazen; then
		unpack ${LB_PATCH} || die
	fi
	popd

	# Move docs out of install dir
	# Readme.txt from 1.31 patch
	mv patches/Readme.txt docs/MicroProse-1.31-Readme.txt || die "mv failed"

	# Docs in unofficial patch
	if use lordbrazen; then
		mv patches/{MOO2v140_readme.txt,ChangeLog.txt} docs || die "mv failed"
	fi

	# Find an icon and convert it to png
	pushd "${CDROM_ROOT}"

	# Original MicroProse icon
	if [ -e ORION2.ICO ]; then
		srcIcon=ORION2.ICO

	# The only icon file on the Hasboro CD
	elif [ -e SIMTEX.ICO ]; then
		srcIcon=SIMTEX.ICO

	# Can we find any icon?
	else
		srcIcon="$(ls -1 *.ICO *.ico 2>/dev/null | awk '{print $1}')"
		test -s "$srcIcon" || die "Can't find an icon on your CD-ROM to use."
	fi

	convert "${srcIcon}" "${WORKDIR}/${PN}.png" || die "convert failed"
}

src_install() {
	local cdDir

	# Main launch script
	dogamesbin "${WORKDIR}/moo2" || die

	# Supporting Bash function libs & default config file
	insinto "${destDir}"
	doins "${FILESDIR}/${PVR}/"{moo2rc,utils.sh,backup.sh} || die

	# Copy CD or create symlink.  Having either a "cdfiles" directory or a
	# "cdlink" symlink in addition to a "cd" symlink that points to one of them
	# is really kinda stupid, but it's a work-around for problems that occur
	# when remerging and changing the nocd option without unmerging first.  If
	# you remove this mechanism, retest!  (portage may fix it one day)
	if use nocd; then
		cdDir=cdfiles

		# Copy the CD to disk
		insinto "${destDir}/cdfiles"
		pushd "${CDROM_ROOT}" || die
		ebegin "Copying CD-ROM files to disk"
		# ebuild complains about directx drivers, so omit them
		doins -r $(ls -1 | egrep -v 'DIRECTX') || die
		eend
		popd
	else
		cdDir=cdlink

		# Create symlink to the CD.  If the user has more than one CD-ROM drive
		# or mount point, this can break later, but they can just re-install or
		# fix it themselves.
		dosym "${CDROM_ROOT}" "${destDir}/cdlink" || die
	fi

	# Create universal symlink for CD
	dosym "${destDir}/${cdDir}" "${destDir}/cd" || die

	# Simulate DOS INSTALL.EXE.
	insinto "${destDir}/MPS/ORION2"

	# If USE=nocd, we use symlinks instead of copying files to save space.  Hard
	# links would work better, but dohard doesn't appear to work if the target
	# does not already exist outside of the sandbox. (bug in dohard or intended
	# functionality?)
	if use nocd; then
		for f in $(cat "${FILESDIR}/installList.txt"); do
			dosym "${destDir}/cd/${f}" "${destDir}/MPS/ORION2/$f" || die
		done
	else
		pushd "${CDROM_ROOT}" || die
		# This step can be slow
		ebegin "Simulating DOS INSTALL.EXE program"
		doins $(cat "${FILESDIR}/installList.txt") || die
		eend
		popd
	fi

	# Install patches.
	doins patches/* || die

	# Install pre-configured .INI files (hardware is simulated, so it's all the
	# same)
	doins "${FILESDIR}/"*.INI || die

	# Icons & menu entries
	doicon "${WORKDIR}/${PN}.png" || die
	make_desktop_entry "${PN}" "${fullGameName}" || die

	# Documentation
	dodoc "${WORKDIR}/docs/"* || die

	# FAQ covering both official and unofficial patched versions.
	dodoc "${FILESDIR}/${PVR}/FAQ.html" || die

	# README.TXT on all CD-ROMs
	dodoc "${CDROM_ROOT}/README.TXT" || die

	# Manual on Hasboro CD-ROM
	if [[ $cdVersion == H1.31 ]]; then
		dodoc "${CDROM_ROOT}/Manual/MOO2manual.pdf" || die
	fi

	prepgamesdirs
}

pkg_postinst() {
	elog "\
A user-level install will be performed the 1st time you run the game. To
change your startup options, edit your ~/.moo2/moo2rc file. See
file:///usr/share/doc/${PF}/FAQ.html for command-line options.
To change your dosbox environment, see the dosbox man page and edit
~/.moo2/dosboxrc.
"
	games_pkg_postinst
}
