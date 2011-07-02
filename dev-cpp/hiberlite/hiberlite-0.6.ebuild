# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

DESCRIPTION="C++ object-relational mapping API inspired by Boost.Serialization"
HOMEPAGE="http://code.google.com/p/hiberlite"
SRC_URI="http://${PN}.googlecode.com/files/${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-db/sqlite:3"
DEPEND="${RDEPEND}
	app-arch/unzip"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc46.patch
}

src_install() {
	emake INSTALL_PREFIX="${D}/usr" install
}
