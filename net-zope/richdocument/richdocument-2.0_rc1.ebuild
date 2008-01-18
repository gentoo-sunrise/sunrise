# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator zproduct

MY_PV="$(delete_version_separator 2 )"
MY_PN="RichDocument"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="An extension of Plone's built-in Document/Page content type."
HOMEPAGE="http://plone.org/products/richdocument"
SRC_URI="http://plone.org/products/richdocument/releases/$(get_version_component_range 1-2)/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=net-zope/plone-2.1"
RDEPEND="${DEPEND}"

ZPROD_LIST="${MY_PN}"
