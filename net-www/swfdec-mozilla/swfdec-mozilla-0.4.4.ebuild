# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib

DESCRIPTION="A decoder/renderer netscape style plugin for Macromedia Flash animations."
HOMEPAGE="http://swfdec.freedesktop.org/"
SRC_URI="http://swfdec.freedesktop.org/download/${PN}/${PV:0:3}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE=""

DEPEND=">=media-libs/swfdec-0.4.4
	|| ( www-client/mozilla-firefox www-client/seamonkey )"
RDEPEND=""

src_install() {
	exeinto /usr/$(get_libdir)/nsbrowser/plugins
	doexe src/.libs/libswfdecmozilla.so || die "libswfdecmozilla.so failed"

	insinto /usr/$(get_libdir)/nsbrowser/plugins
	doins src/libswfdecmozilla.la
}

pkg_postinst() {
	einfo "Remember to report bugs to: https://bugzilla.freedesktop.org/"
}
