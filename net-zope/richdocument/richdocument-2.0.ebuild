# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit versionator zproduct

MY_PN="RichDocument"
MY_P="${MY_PN}-$(replace_version_separator 1 -)"

DESCRIPTION="An extension of Plone's built-in Document/Page content type."
HOMEPAGE="http://plone.org/products/richdocument"
SRC_URI="http://plone.org/products/${Pn}/releases/${PV}/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-zope/plone:2.5"

ZPROD_LIST="${MY_PN}"
