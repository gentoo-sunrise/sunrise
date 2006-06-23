# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="ChuCK - On-the-fly Audio Programming"
HOMEPAGE="http://chuck.cs.princeton.edu/release/"
SRC_URI="http://chuck.cs.princeton.edu/release/files/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="oss jack alsa"


DEPEND="jack? ( media-sound/jack-audio-connection-kit )
	alsa? ( >=media-libs/alsa-lib-0.9 )
	media-libs/libsndfile"

src_compile() {
	cd "${S}/src"

	local backend
	if use jack ; then
		backend="jack"
	elif use alsa ; then
		backend="alsa"
	elif use oss ; then
		backend="oss"
	else
		einfo "One of the following USE flags is needed: jack, alsa or oss"
		die "One of the following USE flags is needed: jack, alsa or oss"
	fi
	einfo "Compiling against ${backend}"
	emake "linux-${backend}" || die "emake failed"
}

src_install() {
	exeinto /usr/bin
	doexe src/chuck

	dodoc AUTHORS COPYING DEVELOPER INSTALL PROGRAMMER QUICKSTART README \
		THANKS TODO VERSIONS
	docinto examples
	dodoc `find examples -type f`
	for dir in `find examples/* -type d`; do
		docinto $dir
		dodoc $dir/*
	done
	docinto doc
	dodoc doc/*
}
