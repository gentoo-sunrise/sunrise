# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="A Command-line ID3 Tag Editor"
HOMEPAGE="http://muennich.github.com/id3ted/"
SRC_URI="http://github.com/downloads/muennich/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="media-libs/taglib
	sys-apps/file"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-gentoo-as-needed.patch"
	epatch "${FILESDIR}/${P}-gentoo-proper-compiler-and-flags.patch"
}

src_compile() {
	emake PREFIX="/usr" || die
}

src_install() {
	emake PREFIX="${D}/usr" install || die
	dodoc CHANGELOG README || die
}
