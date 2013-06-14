# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils eutils versionator

MY_P=${PN}-$(replace_version_separator 3 -)
DESCRIPTION="A lattice solver"
HOMEPAGE="http://zygmuntptak.pl/programs/KRT/"
SRC_URI="http://zygmuntptak.pl/public/programs/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples"

DEPEND="dev-qt/qtgui:4
	dev-qt/qtopengl:4"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_install() {
	_check_build_dir
	dobin "${CMAKE_BUILD_DIR}"/${PN}

	if use examples; then
		docinto examples
		dodoc example/*
	fi

	doicon "${FILESDIR}"/${PN}.xpm
	make_desktop_entry ${PN} ${PN} ${PN} 'Education;Science;Engineering'
}
