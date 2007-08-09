# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Swfdec-mozilla is a decoder/renderer netscape style plugin for Macromedia Flash animations."
HOMEPAGE="http://swfdec.freedesktop.org/"
SRC_URI="http://swfdec.freedesktop.org/download/${PN}/0.5/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=">=media-libs/swfdec-0.5.1
	|| ( www-client/mozilla-firefox www-client/seamonkey )"
RDEPEND=""

src_install() {
	exeinto /usr/lib/nsbrowser/plugins
	doexe src/.libs/libswfdecmozilla.so || die "libswfdecmozilla.so failed"
	insinto /usr/lib/nsbrowser/plugins
	doins src/libswfdecmozilla.la
}

pkg_postinst() {
	elog "Remember to report bugs to: https://bugzilla.freedesktop.org"
}
