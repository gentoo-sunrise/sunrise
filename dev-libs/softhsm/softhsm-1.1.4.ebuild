# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit base

DESCRIPTION="A software PKCS#11 implementation"
HOMEPAGE="http://www.opendnssec.org/"
SRC_URI="http://www.opendnssec.org/files/source/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
IUSE="debug"
SLOT="0"
LICENSE="BSD"

RDEPEND="dev-libs/botan[threads]
	dev-db/sqlite:3"

DEPEND="${RDEPEND}"

DOCS=( "AUTHORS" "NEWS" "README" )

src_configure() {
	local myconf
	use debug && myconf="--with-loglevel=4"

	econf \
	$(use_enable amd64 64bit) \
	$myconf
}
