# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator base toolchain-funcs

MY_P="${PN}-$(replace_all_version_separators - ${PV})"

DESCRIPTION="terminal program that displays disk space utilization in an interactive full-screen folding outline"
HOMEPAGE="http://webonastick.com/tdu/"
SRC_URI="${HOMEPAGE}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-libs/ncurses
	dev-libs/glib"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"
S="${WORKDIR}"/${PN}

PATCHES=( "${FILESDIR}"/${PV}-DESTDIR.patch )

src_compile() {
	emake \
		CC=$(tc-getCC) || \
		die "compilation failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "installation failed"
	dodoc README TODO || die "nothing to read"
}
