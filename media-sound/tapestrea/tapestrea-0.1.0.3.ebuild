# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs flag-o-matic

DESCRIPTION="Techniques And Paradigms for Expressive Synthesis, Transformation, and Rendering of Environmental Audio"
HOMEPAGE="http://taps.cs.princeton.edu/"
SRC_URI="http://taps.cs.princeton.edu/release/files/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="oss jack alsa doc"

RDEPEND="jack? ( media-sound/jack-audio-connection-kit )
	alsa? ( >=media-libs/alsa-lib-0.9 )
	media-libs/libsndfile
	virtual/glut
	virtual/opengl
	virtual/glu
	>=x11-libs/gtk+-2"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-makefile.patch"
}

pkg_setup() {
	local cnt=0
	use jack && cnt="$((${cnt} + 1))"
	use alsa && cnt="$((${cnt} + 1))"
	use oss && cnt="$((${cnt} + 1))"
	if [[ "${cnt}" -eq 0 ]] ; then
		eerror "One of the following USE flags is needed: jack, alsa or oss"
		die "Please set one audio engine type"
	elif [[ "${cnt}" -ne 1 ]] ; then
		ewarn "You have set ${P} to use multiple audio engine."
	fi
}

src_compile() {
	local backend
	if use jack; then
		backend="jack"
	elif use alsa; then
		backend="alsa"
	elif use oss; then
		backend="oss"
	fi
	einfo "Compiling against ${backend}"

	# when compile with athlon or athlon-xp flags
	# chuck crashes on removing a shred with a double free or corruption
	# it happens in Chuck_VM_Stack::shutdown() on the line
	#   SAFE_DELETE_ARRAY( stack );
	replace-cpu-flags athlon athlon-xp i686

	cd "${S}/scripting/chuck-1.2.0.6/src"
	emake -f "makefile.${backend}" CC=$(tc-getCC) CXX=$(tc-getCXX) || die "emake failed"

	cd "${S}/src"
	emake -f "makefile.${backend}" CC=$(tc-getCC) CXX=$(tc-getCXX) || die "emake failed"
}

src_install() {
	dobin src/taps

	dodoc AUTHORS BUGS DEVELOPER PROGRAMMER QUICKSTART README THANKS TODO VERSIONS
	if use doc; then
		for dir in `find examples/* -type d -maxdepth 0`; do
			docinto $dir
			dodoc `find $dir/* -type f -maxdepth 0`
			for dir2 in `find $dir/* -type d -maxdepth 0`; do
				docinto $dir2
				dodoc `find $dir2/* -type f -maxdepth 0`
			done
		done
		docinto doc
		dodoc doc/*
	fi
}
