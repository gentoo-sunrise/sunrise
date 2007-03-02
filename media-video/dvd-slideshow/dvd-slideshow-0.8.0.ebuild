# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Header: $

MY_P=dvd-slideshow-${PV}-1

DESCRIPTION="DVD slideshow creator"
HOMEPAGE="http://dvd-slideshow.sourceforge.net/wiki/Main_Page"
SRC_URI="mirror://sourceforge/dvd-slideshow/${MY_P}.tar.gz
		examples? ( mirror://sourceforge/dvd-slideshow/dvd-slideshow-examples-${PV}-1.tar.gz )
		themes? ( mirror://sourceforge/dvd-slideshow/dvd-slideshow-themes-${PV}-1.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="examples mp3 themes vorbis"

RDEPEND="media-sound/sox
	>media-gfx/imagemagick-5.5.4
	>media-video/dvdauthor-0.6.11
	virtual/cdrtools
	>media-video/ffmpeg-0.4.8
	app-cdr/dvd+rw-tools
	mp3? ( media-sound/lame )
	vorbis? ( media-libs/libvorbis )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"


S="${WORKDIR}/${MY_P}"

#  using install.sh provided by dvd-slideshow can cause a sandbox violation
src_install() {
	cd "${S}"
	dobin dvd-slideshow dvd-menu gallery1-to-slideshow jigl2slideshow dir2slideshow
	dodoc BUGS.txt TODO.txt
	dohtml *.html
	doman man/*

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/*
	fi
	
	if use themes ; then
		insinto /usr/share/themes/${PF}/
		doins -r themes/*
	fi
	
	make_desktop_entry dvd-slideshow Application
}
