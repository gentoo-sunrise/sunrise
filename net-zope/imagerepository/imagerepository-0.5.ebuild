# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit zproduct

MY_PN="ImageRepository"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A centralized image repository with keyword/tag-based browsing and filtering"
HOMEPAGE="http://plone.org/products/imagerepository"
SRC_URI="http://plone.org/products/imagerepository/releases/${PV}/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="kupu"

DEPEND="net-zope/plone"
RDEPEND="${DEPEND}
	kupu? ( net-zope/kupu )"

ZPROD_LIST="${MY_PN}"
