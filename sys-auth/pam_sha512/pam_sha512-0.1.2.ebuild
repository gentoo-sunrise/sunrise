# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic pam toolchain-funcs

DESCRIPTION="Pam module to allow authentication via sha512 hash'ed passwords."
HOMEPAGE="http://hollowtube.mine.nu/wiki/index.php?n=Projects.PamSha512"
SRC_URI="http://hollowtube.mine.nu/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="sys-libs/pam"
RDEPEND="${DEPEND}
	app-crypt/hashalot"

src_compile() {
	append-flags "-fPIC -c -Wall -Wformat-security"
	emake CC=$(tc-getCC) \
		  LD=$(tc-getLD) \
		  CFLAGS="${CFLAGS}" || die "emake failed"
		  # CFLAGS="${CFLAGS}" is required
}

src_install() {
	dopammod pam_sha512.so
	dodoc README
	dosbin hashpass
}
