# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="A command line podcast receiver that supports downloads via HTTP and BitTorrent"
HOMEPAGE="http://www.peapodpy.org/"
SRC_URI="http://peapodpy.org/downloads/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
SLOT="0"
IUSE="id3 bittorrent vorbis"

DEPEND="dev-python/pyxml
	>=dev-python/urlgrabber-2.9.6
	bittorrent? ( >=net-p2p/bittorrent-4.0.0 )
	id3? ( dev-python/eyeD3 )
	vorbis? ( media-sound/vorbis-tools )"

RDEPEND=${DEPEND}

DOCS="README docs/about.txt docs/configuration.txt docs/dependencies.txt docs/getting.txt docs/using.txt"

pkg_postinst() {
	elog "Start by running peapod"
	elog "Then edit the file in .peapod/peapod.xml with the feeds"
	elog "For reference look at /usr/share/doc/${PF}/configuration.txt.gz"
}

src_install() {
	distutils_src_install
	use bittorrent || rm -f "${D}/usr/bin/btclient.py"
}
