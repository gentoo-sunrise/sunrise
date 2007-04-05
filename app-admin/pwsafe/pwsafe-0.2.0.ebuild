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
IUSE=""

DEPEND=""
RDEPEND=""

src_compile() {
	append-ldflags $(bindnow-flags)
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README ChangeLog AUTHORS TODO NEWS
	fperms +s /usr/bin/pwsafe
}

pkg_postinst() {
	einfo "For the secure memory allocation to work, pwsafe has been installed"
	einfo "as suid root."
}
