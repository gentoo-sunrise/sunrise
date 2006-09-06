# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic

DESCRIPTION="Manages encrypted password databases (compatible with Counterpane's Password Safe)."
HOMEPAGE="http://nsd.dyndns.org/pwsafe/"
SRC_URI="http://nsd.dyndns.org/pwsafe/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_compile() {
	append-ldflags -Wl,-z,now
	econf
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README ChangeLog AUTHORS TODO
	chmod +s "${D}/usr/bin/pwsafe"
}

pkg_postinst() {
	einfo "For the secure memory allocation to work, pwsafe has been installed"
	einfo "as suid root."
}
