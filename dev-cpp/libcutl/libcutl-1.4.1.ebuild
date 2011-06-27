# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit versionator

DESCRIPTION="Library of C++ utilities with evil buildsystem"
HOMEPAGE="http://codesynthesis.com/projects/libcutl/"
SRC_URI="http://codesynthesis.com/download/${PN}/$(get_version_component_range 1-2)/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

src_install() {
	default
	dodoc NEWS README
}
