# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Convert between any document format supported by OpenOffice"
HOMEPAGE="http://dag.wieers.com/home-made/unoconv/"
SRC_URI="http://dag.wieers.com/home-made/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-text/asciidoc
	dev-python/setuptools"
RDEPEND="|| ( app-office/openoffice app-office/openoffice-bin )"

src_prepare() {
	epatch "${FILESDIR}/${P}-openoffice-3.2.patch" \
		"${FILESDIR}/${P}-longer-timeout.patch"
}

src_install() {
	emake install DESTDIR="${D}" bindir='$(prefix)/share/unoconv' || die
	newbin "${FILESDIR}"/unoconv-wrapper unoconv || die
}
