# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

MY_PV=$(replace_version_separator 2 '')

DESCRIPTION="A program that generates images from instructions written in context-free grammar"
HOMEPAGE="http://www.contextfreeart.org/"
SRC_URI="http://www.contextfreeart.org/download/ContextFreeSource${MY_PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="media-libs/libpng"

S="${WORKDIR}/ContextFreeSource${MY_PV}"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/${P}-fix-cpp-headers.patch"
}

src_install() {
	dobin cfdg || die
}

src_test() {
	make rtests OUTPUT_DIR="${T}" || die "tests failed"
}
