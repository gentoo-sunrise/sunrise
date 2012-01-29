# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit pam

DESCRIPTION="Toolkit for using one-time password authentication with HOTP/TOTP algorithms"
HOMEPAGE="http://www.nongnu.org/oath-toolkit/"
SRC_URI="http://download.savannah.gnu.org/releases/${PN}/${P}.tar.gz"
LICENSE="GPL-3 LGPL-2.1"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pam"

DEPEND="pam? ( virtual/pam )"
RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_enable pam) --with-pam-dir=$(getpam_mod_dir)
}

src_install() {
	default
	if use pam; then
		newdoc pam_oath/README README.pam
	fi
}
