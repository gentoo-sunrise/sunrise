# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools base eutils

DESCRIPTION="A software PKCS#11 implementation"
HOMEPAGE="http://www.opendnssec.org/"
SRC_URI="http://www.opendnssec.org/files/source/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
IUSE="debug"
SLOT="0"
LICENSE="BSD"

RDEPEND=">=dev-libs/botan-1.8.5[threads]
	>=dev-db/sqlite-3.4.2"

DEPEND="${RDEPEND}"

DOCS=( "AUTHORS" "NEWS" "README" )

src_prepare() {
	# fixes for broken configure switches
	epatch "${FILESDIR}"/"${P}"-r2797.patch
	epatch "${FILESDIR}"/"${P}"-r2798.patch
	eautoreconf
}

src_configure() {
	local myconf
	use debug && myconf="--with-loglevel=4"

	econf \
	$(use_enable amd64 64bit) \
	$myconf
}
