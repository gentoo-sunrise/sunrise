# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P=${P/gtk-engines-/}

DESCRIPTION="Murrine GTK+2 Cairo Engine"
HOMEPAGE="http://cimi.netsons.org/pages/murrine.php"
SRC_URI="http://cimi.netsons.org/media/download_gallery/murrine/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="animation"

RDEPEND=">=x11-libs/gtk+-2.8"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.20"

S=${WORKDIR}/${MY_P}

src_compile() {
	econf $(use_enable animation) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
