# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A YouTube Downloader and Converter"
HOMEPAGE="http://sourceforge.net/projects/elltube"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/PyQt4
	media-video/ffmpeg"

src_unpack() {
	unpack ${A}
	rm "${S}"/Makefile
}

src_install() {
	insinto /usr/share/elltube
	doins -r elltube.py atom gdata img || die "doins failed"
	domenu elltube.desktop
	insinto /usr/share/elltube/locale
	doins locale/*.qm || die "doins failed"
	echo -e "#!/usr/bin/env sh\ncd /usr/share/elltube/\npython elltube.py" > ${PN}
	dobin ${PN} || die "dobin failed"
	doicon img/elltube.png || die "doicon failed"
	dodoc CHANGELOG || die "dodoc failed"
}
