# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils toolchain-funcs multilib

DESCRIPTION="PAM Module for two step verification via mobile platform"
HOMEPAGE="http://code.google.com/p/google-authenticator/"
SRC_URI="http://${PN}.googlecode.com/files/libpam-${P}-source.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/pam"

RDEPEND="${DEPEND}"

RESTRICT="test"
# Test fails with:
# pam_google_authenticator_unittest: pam_google_authenticator_unittest.c:317: main: Assertion `pam_sm_open_session(((void *)0), 0, targc, targv) == 0' failed.
# No user name available when checking verification code

S=${WORKDIR}/libpam-${P}

src_prepare(){
	epatch "${FILESDIR}"/${P}-Makefile.patch
	tc-export CC
}

src_install(){
	dodoc README
	insinto $(get_libdir)/security
	doins pam_google_authenticator.so
	dobin google-authenticator
}

pkg_postinst(){
	elog "Add this line to your PAM configuration file in /etc/pam.d:"
	elog "auth required pam_google_authenticator.so"
	elog ""
	elog "If you want support for QR-Codes, install media-gfx/qrencode."
}
