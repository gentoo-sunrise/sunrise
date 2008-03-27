# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games flag-o-matic

MY_PV=${PV/./}
# Minor releases
MY_PV=${MY_PV/_p/u}
MY_P=${PN}${MY_PV}
MY_V=${PV%%_p*}

DESCRIPTION="Multiple Arcade Machine Emulator (SDL)"
HOMEPAGE="http://rbelmont.mameworld.info/?page_id=163"
# Hope it goes to gentoo mirrors...
#SRC_URI="mirror://gentoo/${MY_P}.zip"
SRC_URI="http://rbelmont.mameworld.info/${MY_P}.zip
http://dev.gentooexperimental.org/~jokey/sunrise-dist/patch-0.120a.tar.bz2"

# Same as xmame. Should it be renamed to MAME?
LICENSE="XMAME"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="minimal debug"

DEPEND=">=media-libs/libsdl-1.2.10
	sys-libs/zlib
	dev-libs/expat
	debug? (
		>gnome-base/gconf-2
		>=x11-libs/gtk+-2 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

RESTRICT="fetch strip"

pkg_nofetch() {
	einfo "Please download"
	einfo "${SRC_URI}"
	einfo "and put the files in ${DISTDIR}"
	einfo
}

# Function to disable a makefile option
disable_feature() {
	sed -i \
		-e "/$1.*=/s:^:# :" \
		"${S}"/makefile || die "disable $1 patch failed"
}

# Function to enable a makefile option
enable_feature() {
	sed -i \
		-e "/^#.*$1.*=/s:^# ::"  \
		"${S}"/makefile || die "enable $1 patch failed"
}

src_unpack() {
	unpack ${A}
	# Don't compile zlib and expat
	einfo "Disabling embedded libraries: zlib and expat"
	$(disable_feature BUILD_ZLIB)
	$(disable_feature BUILD_EXPAT)

	case ${ARCH} in
		amd64)
			einfo "Enabling 64-bit support"
			$(enable_feature PTR64)
			$(enable_feature AMD64)
			;;

		x86)
			einfo "Optimizing build for $(get-flag march)"
			case $(get-flag march) in
				pentium3)	$(enable_feature PM);;
				pentium-m)	$(enable_feature PM);;
				pentium4)   $(enable_feature P4);;
				athlon)		$(enable_feature ATHLON);;
				k7)			$(enable_feature ATHLON);;
				i686)		$(enable_feature I686);;
				pentiumpro)	$(enable_feature I686);;
			esac
			;;

		ppc)
			einfo "Enabling PPC support"
			$(enable_feature G4)
			;;
	esac

	if use debug ; then
		$(enable_feature DEBUG)
		$(enable_feature SYMBOLS)
		$(enable_feature PROFILE)
	fi

	einfo "Applying WolfMAME patches"
	cd "${S}"
	epatch "${WORKDIR}"/patch-${MY_V}/dipports.patch
	epatch "${WORKDIR}"/patch-${MY_V}/inpview.patch
	epatch "${WORKDIR}"/patch-${MY_V}/wolf.patch
}

src_compile() {
	# Minimal driver support. Good for ebuild testing...
	if use minimal ; then
		make_opts="SUBTARGET=tiny"
	fi

	emake \
		NAME=${PN} \
		SUFFIX="" \
		${make_opts} \
		|| die "emake failed"
}

src_install() {
	dogamesbin ${PN} || die "dogamesbin ${PN} failed"

	# Follows xmame ebuild, avoiding collision on /usr/games/bin/jedutil
	exeinto $(games_get_libdir)/${PN}
	local f
	for f in chdman jedutil romcmp ; do
		doexe "${f}" || die "doexe ${f} failed"
	done

	dodoc docs/* *.txt

	prepgamesdirs
}
