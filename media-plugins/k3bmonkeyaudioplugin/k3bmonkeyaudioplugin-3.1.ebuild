# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt3

DESCRIPTION="K3b Monkey's Audio Encoder and Decoder plugin"
HOMEPAGE="http://www.k3b.org"
SRC_URI="mirror://sourceforge/k3b/${P}.tar.bz2"

LICENSE="GPL-2 MonkeyAudio"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="arts"
RESTRICT="fetch"

DEPEND="app-cdr/k3b[arts?]
	arts? ( kde-base/arts )"
RDEPEND="${DEPEND}"

pkg_nofetch() {
	einfo "The license for the bundled MonkeyAudio codec sucks."
	einfo "You must download the tarball manually."
	einfo
	einfo "Please download ${P}.tar.bz2"
	einfo "from ${HOMEPAGE} and place it to ${DISTDIR}."
}

src_configure() {
	econf $(use_with arts)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README TODO || die "dodoc failed"
}
