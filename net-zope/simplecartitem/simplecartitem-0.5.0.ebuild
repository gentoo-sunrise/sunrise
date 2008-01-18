# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit zproduct

MY_PN="SimpleCartItem"
MY_PV="${PV:0:3}"

DESCRIPTION="Content type that allows for integration with online stores such as
PayPal store"
HOMEPAGE="http://plone.org/products/simplecartitem"
SRC_URI="http://plone.org/products/simplecartitem/releases/${MY_PV}/${MY_PN}.tar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=net-zope/plone-2.1"
RDEPEND="${DEPEND}
	>=net-zope/datagridfield-1.5.0"
	# the docs say that >=net-zope/datagridfield-1.5.2_rc2 is required, but
	# such a release cannot be found; the latest is 1.5.0.

ZPROD_LIST="${MY_PN}"
