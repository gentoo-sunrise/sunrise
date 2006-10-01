# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_PN="murrine"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Murrine GTK+2 Cairo Engine"
HOMEPAGE="http://cimi.netsons.org/pages/murrine.php"
SRC_URI="http://cimi.netsons.org/media/download_gallery/${MY_PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="animation"

RDEPEND=">=x11-libs/gtk+-2.8"
DEPEND="${RDEPEND}
		>=dev-util/pkgconfig-0.9"

S="${WORKDIR}/${MY_P}"

src_compile() {
	econf $(use_enable animation) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
