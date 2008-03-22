# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOMAKE="none"
WANT_AUTOCONF="latest"

inherit autotools

DESCRIPTION="The free software you have always wanted to manage your personal accounts at home"
HOMEPAGE="http://homebank.free.fr/index.php"
SRC_URI="http://homebank.free.fr/public/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE="ofx"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=x11-libs/gtk+-2.0
	ofx? ( >=dev-libs/libofx-0.7 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i \
		-e 's|LDFLAGS="${LDFLAGS} -lofx"|LIBS="${LIBS} -lofx"|' \
		configure.ac || die "sed failed"

	eautoconf
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
