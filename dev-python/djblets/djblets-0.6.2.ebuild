# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit distutils python versionator

MY_PN="Djblets"

DESCRIPTION="A collection of useful extensions for Django"
HOMEPAGE="http://github.com/djblets"
SRC_URI="http://downloads.reviewboard.org/releases/${MY_PN}/$(get_version_component_range 1-2)/${MY_PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/django
	dev-python/imaging"

src_prepare() {
	rm -r tests || die
	distutils_src_prepare
}
