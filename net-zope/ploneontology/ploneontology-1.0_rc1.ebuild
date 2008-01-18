# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator zproduct

MY_PV="$(delete_version_separator 2)"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="PloneOntology is an ontology based replacement for the existing keyword mechanism in Plone."
HOMEPAGE="http://plone.org/products/ploneontology/"
SRC_URI="http://plone.org/products/ploneontology/releases/${MY_PV}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="net-zope/relations
	media-gfx/graphviz"

ZPROD_LIST="PloneOntology"
