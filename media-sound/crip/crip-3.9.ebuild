# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KEYWORDS="~x86"

DESCRIPTION="A terminal-based ripper/encoder/tagger tool for creating Ogg Vorbis and FLAC files."
HOMEPAGE="http://bach.dynet.com/crip/index.html"
SRC_URI="http://bach.dynet.com/${PN}/src/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE="normalize"

DEPEND=""
RDEPEND="dev-lang/perl
	dev-perl/CDDB_get
	virtual/perl-Getopt-Long
	media-sound/cdparanoia
	media-libs/flac
	media-sound/vorbis-tools
	normalize? ( >=media-sound/sox-12.17.4 )
	!normalize? ( media-sound/vorbisgain )"

src_install() {
	dobin crip editcomment editfilenames
	dodoc Changelog README TODO criprc_example
}

pkg_postinst() {
	elog "A sample .criprc file has been installed as ${ROOT}usr/share/doc/${PF}/criprc_example.gz"
}
