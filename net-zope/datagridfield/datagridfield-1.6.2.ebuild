# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit zproduct

MY_PN="DataGridField"

DESCRIPTION="A table input component for Plone"
HOMEPAGE="http://plone.org/products/datagridfield"
SRC_URI="http://plone.org/products/${PN}/releases/${P}/Products.${MY_PN}-${PV}.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="net-zope/plone"

ZPROD_LIST="${MY_PN}"
