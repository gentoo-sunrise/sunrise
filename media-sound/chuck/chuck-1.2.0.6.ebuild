# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

DESCRIPTION="ChuCK - On-the-fly Audio Programming"
HOMEPAGE="http://chuck.cs.princeton.edu/release/"
SRC_URI="http://chuck.cs.princeton.edu/release/files/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="oss jack alsa doc"

DEPEND="jack? ( media-sound/jack-audio-connection-kit )
	alsa? ( >=media-libs/alsa-lib-0.9 )
	media-libs/libsndfile
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
		local msg="One of the following USE flags is needed: jack, alsa or oss"
		eerror "${msg}"
		die "${msg}"
	elif [[ "${cnt}" -ne 1 ]] ; then
		eerror "You have set ${P} to use multiple audio engine."
		eerror "I don't know which to use!"
		eerror "You can use /etc/portage/package.use to set per-package USE flags"
		eerror "Set it so only one audio engine type jack, alsa, oss"
		die "Please set only one audio engine type"
	fi
}

src_compile() {
	cd "${S}/src"

	local backend
	if use jack ; then
		backend="jack"
	elif use alsa ; then
		backend="alsa"
	elif use oss ; then
		backend="oss"
	fi
	einfo "Compiling against ${backend}"
	emake -f "makefile.${backend}" CC=$(tc-getCC) CXX=$(tc-getCXX) || die "emake failed"
}

src_install() {
	dobin src/chuck

	dodoc AUTHORS DEVELOPER PROGRAMMER QUICKSTART README THANKS TODO VERSIONS
	if use doc; then
		docinto examples
		dodoc `find examples -type f`
		for dir in `find examples/* -type d`; do
			docinto $dir
			dodoc $dir/*
		done
		docinto doc
		dodoc doc/*
	fi
}
