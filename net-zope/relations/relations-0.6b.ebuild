# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit zproduct

PKG="relations-0-6b-tar.gz"

DESCRIPTION="Relations allows for component-wise control of validation, creation
and lifetime of Archetypes references."
HOMEPAGE="http://plone.org/products/relations/"
SRC_URI="http://plone.org/products/relations/releases/${PV}/${PKG}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

RDEPEND="net-zope/archetypes"

ZPROD_LIST="Relations"

src_unpack() {
	# this has to be done manually since $A is incorrect, and readonly
	# unpack function does not work either
	tar xzf ${DISTDIR}/${PKG} -C ${WORKDIR}
}

src_install() {
	zproduct_src_install all
}
