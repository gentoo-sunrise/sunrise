# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools

DESCRIPTION="Encrypting and deciphering of messages with the RSA asymmetrical encryption algorithm"
HOMEPAGE="http://www.erikyyy.de/yyyRSA/"
SRC_URI="http://www.erikyyy.de/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/gmp"
RDEPEND="${DEPEND}"

src_prepare() {
	# Fix stripped binaries and missing includes.
	epatch "${FILESDIR}"/${P}-compile-fix.patch
	epatch "${FILESDIR}"/${P}-build-fix.patch
	eautoreconf
}
