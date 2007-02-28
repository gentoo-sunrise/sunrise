# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils qt4 subversion

DESCRIPTION="Tool for removing advertisements from recorded MPEG files"
HOMEPAGE="http://ttcut.tritime.org/"
ESVN_REPO_URI="http://svn.berlios.de/svnroot/repos/ttcut/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="ttmpeg2"

DEPEND="$(qt4_min_version 4.1)
		>=media-libs/libmpeg2-0.4.0"

RDEPEND="${DEPEND}
		media-video/mplayer
		media-video/dvdauthor
		media-video/transcode
		media-video/ffmpeg"

S=${WORKDIR}/${PN}

src_compile() {
	if use ttmpeg2 ; then
		qmake ttmpeg2.pro -o Makefile.ttmpeg2 || \
			die "configuring ttpmeg2 failed"
		make -f Makefile.ttmpeg2 || die "emake ttmpeg2 failed"
	fi

	qmake ttcut.pro -o Makefile.ttcut || \
		die "configuring ttcut failed"
	emake -f Makefile.ttcut || die "emake failed"
}

src_install() {
	if use ttmpeg2 ; then
		dobin ttmpeg2 || die "Couldn't install ttmpeg2"
		make_desktop_entry ttmpeg2 Ttmpeg2 "" AudioVideoEditing || \
			die "Couldn't make ttmpeg2 desktop entry"
	fi

	dobin ttcut || die "Couldn't install ttcut"
	make_desktop_entry ttcut Ttcut "" AudioVideoEditing || \
		die "Couldn't make ttcut desktop entry"
}
