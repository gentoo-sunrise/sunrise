# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic

DESCRIPTION="Commandline program that manages encrypted password databases (compatible with Counterpane's Password Safe)"
HOMEPAGE="http://nsd.dyndns.org/pwsafe/"
SRC_URI="http://nsd.dyndns.org/pwsafe/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="suid X"

RDEPEND="X? ( x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libSM
	x11-libs/libICE
	x11-libs/libXt
	x11-libs/libXext
	x11-libs/libXau
	x11-libs/libXdmcp )
	dev-libs/openssl
	sys-libs/readline
	sys-libs/ncurses"
DEPEND="${RDEPEND} X? ( x11-proto/xproto )"

src_compile() {
	if use suid; then
		append-ldflags $(bindnow-flags)
	fi
	econf $(use_with X x) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README ChangeLog AUTHORS TODO NEWS
	if use suid; then
		fperms +s /usr/bin/pwsafe
	fi
}

pkg_postinst() {
	if use suid; then
		einfo "For the secure memory allocation to work, pwsafe has been installed"
		einfo "as suid root."
	fi
}
