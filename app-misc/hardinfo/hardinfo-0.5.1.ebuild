# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils flag-o-matic

DESCRIPTION="A system information and benchmark tool for Linux systems"
HOMEPAGE="http://hardinfo.berlios.de/"
SRC_URI="mirror://berlios/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	net-libs/libsoup
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/makefile.patch
}

src_configure() {
	filter-flags "-O*"
	econf
}

src_compile() {
	emake -j1
}
