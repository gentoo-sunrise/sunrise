# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

DESCRIPTION="real-time audio visualization"
HOMEPAGE="http://soundlab.cs.princeton.edu/software/sndpeek/"
SRC_URI="http://soundlab.cs.princeton.edu/software/${PN}/files/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="oss jack alsa"

DEPEND="virtual/glut
	virtual/opengl
	virtual/glu
	x11-libs/libXmu
	x11-libs/libX11
	x11-libs/libXext
	jack? ( media-sound/jack-audio-connection-kit )
	alsa? ( media-libs/alsa-lib )"
RDEPEND="${DEPEND}"

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
	if [[ "${cnt}" -eq 0 ]]; then
		eerror "One of the following USE flags is needed: jack, alsa or oss"
		die "Please set one audio engine type"
	elif [[ "${cnt}" -ne 1 ]]; then
		ewarn "You have set ${P} to use multiple audio engine."
	fi
}

src_compile() {
	cd "${S}/src/sndpeek"

	local backend
	if use jack; then
		backend="jack"
	elif use alsa; then
		backend="alsa"
	elif use oss; then
		backend="oss"
	fi
	einfo "Compiling against ${backend}"
	emake -f "makefile.${backend}" CC=$(tc-getCC) CXX=$(tc-getCXX) || die "emake failed"
}

src_install() {
	dobin src/sndpeek/sndpeek

	dodoc AUTHORS README THANKS TODO VERSIONS
}
