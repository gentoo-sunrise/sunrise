# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit zproduct

# a bit unorthodox naming...
PKG="ploneontology-1-0rc1-tar.gz"
VER="1.0rc1"

DESCRIPTION="PloneOntology is an ontology based replacement for the existing
keyword mechanism in Plone."
HOMEPAGE="http://plone.org/products/ploneontology"
SRC_URI="http://plone.org/products/ploneontology/releases/${VER}/${PKG}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

RDEPEND="net-zope/relations
         media-gfx/graphviz"

ZPROD_LIST="PloneOntology"

src_unpack() {
	# this has to be done manually since $A is incorrect, and readonly
	# unpack function does not work either
	tar xzf ${DISTDIR}/${PKG} -C ${WORKDIR}
}

src_install() {
	zproduct_src_install all
}
