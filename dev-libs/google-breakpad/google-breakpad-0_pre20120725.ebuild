# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools eutils

DESCRIPTION="An open-source multi-platform crash reporting system"
HOMEPAGE="http://code.google.com/p/google-breakpad/"
SRC_URI="mirror://github/jauhien/sources/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"

IUSE="processor tools"

DEPEND="net-misc/curl"
RDEPEND="${DEPEND}"

src_prepare() {
	rm -rf src/third_party/{curl,glog,linux,protobuf} || die
	epatch "${FILESDIR}/${P}-curl.patch"
	epatch "${FILESDIR}/${P}-package-name.patch"
	epatch "${FILESDIR}/${P}-headers.patch"
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable processor ) \
		$(use_enable tools )
}
