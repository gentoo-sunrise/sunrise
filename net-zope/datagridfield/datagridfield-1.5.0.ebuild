# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit zproduct

MY_PN="DataGridField"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A table input component for Plone"
HOMEPAGE="http://plone.org/products/datagridfield"
SRC_URI="http://plone.org/products/datagridfield/releases/${PV}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=net-zope/plone-2.1"
RDEPEND="${DEPEND}"

ZPROD_LIST="${MY_PN}"
