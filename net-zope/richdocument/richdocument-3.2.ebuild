# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit zproduct

MY_PN="RichDocument"

DESCRIPTION="An extension of Plone's built-in Document/Page content type."
HOMEPAGE="http://plone.org/products/richdocument"
SRC_URI="http://plone.org/products/${PN}/releases/${P}/Products.${MY_PN}-${PV}.tar.gz -> ${PN}.tar.gz"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-zope/plone:3.0"

ZPROD_LIST="${MY_PN}"
