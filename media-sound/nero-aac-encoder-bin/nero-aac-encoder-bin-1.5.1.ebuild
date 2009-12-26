# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Nero free (as in beer) AAC encoder"
HOMEPAGE="http://www.nero.com/eng/technologies-aac-codec.html"
SRC_URI="NeroAACCodec-${PV}.zip"

LICENSE="Nero-AAC-encoder"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
# We need a proper way to specify dependency on multlib profile on amd64
RDEPEND="amd64? ( sys-devel/gcc[multilib]
	sys-libs/glibc[multilib] )"

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
