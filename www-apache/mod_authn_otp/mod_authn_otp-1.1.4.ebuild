# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit apache-module

DESCRIPTION="An Apache module for two-factor authentication (HOTP/OATH)"
HOMEPAGE="http://code.google.com/p/mod-authn-otp/"
SRC_URI="http://mod-authn-otp.googlecode.com/files/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

APACHE2_MOD_CONF="70_${PN}"
APACHE2_MOD_DEFINE="AUTHN_OTP"

DOCFILES="README users.sample CHANGES"

need_apache2

src_compile() {
	default
}

src_install() {
	apache-module_src_install
	doman otptool.1 || die "doman failed"
	dobin otptool || die "dobin failed"
}

pkg_postinst(){
	apache-module_pkg_postinst
	elog "For configuration information see:"
	elog "	http://code.google.com/p/mod-authn-otp/wiki/Configuration"
}
