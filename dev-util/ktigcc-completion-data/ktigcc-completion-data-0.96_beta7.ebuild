# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator

DESCRIPTION="completion data for ktigcc"
HOMEPAGE="http://tigcc.ticalc.org/"
PATCH_LEVEL="r1-1"
MY_PV=$(get_version_component_range 1-2)b0${PV: -1}
SRC_URI="mirror://sourceforge/tigcc-linux/${PN}-${MY_PV}${PATCH_LEVEL}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""

RDEPEND="~dev-embedded/tigcc-${PV}"

src_install() {
	insinto /usr/share/apps/ktigcc
	doins "${WORKDIR}"/completion
}
