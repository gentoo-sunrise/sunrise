# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="Automatic open port forwarder using UPnP"
HOMEPAGE="http://github.com/mgorny/autoupnp/"
SRC_URI="http://github.com/downloads/mgorny/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="libnotify"

RDEPEND="net-misc/miniupnpc
	libnotify? ( x11-libs/libnotify )"
DEPEND="${RDEPEND}"

src_compile() {
	tc-export CC
	emake WANT_LIBNOTIFY=$(use libnotify && echo true || echo false) || die
}

src_install() {
	dolib ${PN}.so || die
	dobin ${PN} || die

	dodoc README || die
}

pkg_postinst() {
	elog "Please notice that AutoUPnP was rewritten in the form of a C LD_PRELOAD"
	elog "library, and thus it has to be enabled for a particular program to have"
	elog "its ports redirected. To enable it for the current user, call:"
	elog "	$ autoupnp install"
}
