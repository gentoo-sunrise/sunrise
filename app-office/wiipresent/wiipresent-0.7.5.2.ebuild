# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="Small program that enables you to use a Nintendo Wiimote for giving presentations"
HOMEPAGE="http://dag.wieers.com/home-made/wiipresent/"
SRC_URI="http://dag.wieers.com/home-made/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="=dev-libs/libwiimote-9999*"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PV}-include.patch \
		"${FILESDIR}"/${PV}-LDFLAGS.patch
}

src_compile() {
	emake \
		CC=$(tc-getCC) \
		CFLAGS="${CFLAGS}" || \
		die "compilation failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "installation failed"
	dodoc AUTHORS ChangeLog README TODO || die "nothing to read"
}
