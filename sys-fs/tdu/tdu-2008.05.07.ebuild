# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils versionator toolchain-funcs

MY_P="${PN}-$(replace_all_version_separators - ${PV})"

DESCRIPTION="terminal program that displays disk space utilization in an interactive full-screen folding outline"
HOMEPAGE="http://webonastick.com/tdu/"
SRC_URI="${HOMEPAGE}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	sys-libs/ncurses
	dev-libs/glib:2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"
S="${WORKDIR}"/${PN}

src_prepare() {
	epatch \
		"${FILESDIR}"/${PV}-DESTDIR.patch \
		"${FILESDIR}"/${PV}-asneeded.patch
	tc-export CC
}
