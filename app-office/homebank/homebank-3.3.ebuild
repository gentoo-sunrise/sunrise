# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P=${P}_unstable

DESCRIPTION="The free software you have always wanted to manage your personal accounts at home"
HOMEPAGE="http://homebank.free.fr/index.php"
SRC_URI="http://homebank.free.fr/public/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE="ofx"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=x11-libs/gtk+-2.0
	ofx? ( >=dev-libs/libofx-0.7 )"
DEPEND="${REPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/${P}-libofx.patch"
}

src_compile() {
	econf \
		$(use_with ofx)
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
