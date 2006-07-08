# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Lightweight PDF viewer"
HOMEPAGE="http://www.emma-soft.com/projects/epdfview/"
SRC_URI="http://www.emma-soft.com/projects/epdfview/chrome/site/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cups nls test"

COMMON_DEPEND=">=x11-libs/gtk+-2.6
		>=app-text/poppler-bindings-0.5.0
		cups? ( >=net-print/cups-1.1 )"

DEPEND="${COMMON_DEPEND}
	>=dev-util/pkgconfig-0.9
	test? ( dev-util/cppunit )
	nls? ( sys-devel/gettext )"

RDEPEND="${COMMON_DEPEND}
	nls? ( virtual/libintl )"


pkg_setup() {
	if ! built_with_use app-text/poppler-bindings gtk; then
		eerror "Please re-emerge app-text/poppler-binding with the gtk USE flag set."
		die "poppler-bindings needs gtk flag set."
	fi
}

src_compile() {
	econf \
		$(use_enable cups) \
		$(use_with nls) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS NEWS README THANKS
}
