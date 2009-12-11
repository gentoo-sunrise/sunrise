# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Nero free (as in beer) AAC encoder"
HOMEPAGE="http://www.nero.com/eng/technologies-aac-codec.html"
SRC_URI="NeroDigitalAudio-${PV}.zip"

LICENSE="Nero-AAC-encoder"

SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

DEPEND="app-arch/unzip"
RDEPEND=""
IUSE=""

RESTRICT="fetch"

pkg_nofetch() {
	einfo "You need to download the file ${SRC_URI} from"
	einfo "http://www.nero.com/eng/downloads-nerodigital-nero-aac-codec.php"
	einfo "and put it to /usr/portage/distfiles manually"
	einfo "due to license restrictions."
}

src_install() {
	      dobin linux/* || die

	      dodoc readme.txt changelog.txt || die
}
