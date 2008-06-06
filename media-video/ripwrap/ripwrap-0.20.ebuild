# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit perl-app

DESCRIPTION="gtk-perl wrapper for mencoder and mp4box with scripting support"
HOMEPAGE="http://sourceforge.net/projects/ripwrap/"
SRC_URI="mirror://sourceforge/ripwrap/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="aac mp2 mp3 x264 mp4"

DEPEND="dev-lang/perl
		dev-perl/gtk2-perl
		>=media-video/lsdvd-0.10
		media-video/mplayer
		mp4? ( media-video/gpac )"

pkg_setup() {
	if ! built_with_use media-video/mplayer encode; then
		eerror "ripwrap requires mplayer to be installed with the encode use"
		eerror "flag set. Please recompile mplayer with USE=\"encode\": "
		eerror "USE=\"encode\" emerge mplayer"
		die "MEncoder not installed!"
	fi

	for i in aac mp2 mp3 x264; do
		if use $i && ! built_with_use media-video/mplayer $i; then
			eerror "You have enabled $i support, but mplayer needs to compiled with"
			eerror "USE=$i to support $i. Please recompile mplayer with $i"
			eerror "support or disable the $i use flag"
			die "$i support not available"
		fi
	done
}
