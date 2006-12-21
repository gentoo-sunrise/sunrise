# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator zproduct

MY_PV="$(delete_version_separator 2 )"
MY_PN="RichDocument"
MY_P="${MY_PN}-${MY_PV}"
S="${WORKDIR}/${MY_PN}"

DESCRIPTION="An extension of Plone's built-in Document/Page content type."
HOMEPAGE="http://plone.org/products/richdocument"
SRC_URI="http://plone.org/products/richdocument/releases/$(get_version_component_range 1-2)/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND=">=net-zope/plone-2.1"
RDEPEND="${DEPEND}"

ZPROD_LIST="${MY_PN}"

src_install() {
	# zproduct requires a lower folder level,
	# there has to be /usr/share/zproduct/$P/$MY_PN/,
	# which has the contents from $WORKDIR/$MY_PN/$MY_PN/
	dodir ${MY_PN}
	mv * ${MY_PN} 2>/dev/null || die # can't move a folder into itself..

	zproduct_src_install all || die
}
