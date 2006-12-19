# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator zproduct

MY_PV="$(replace_version_separator 1 '-' )"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Relations allows for component-wise control of validation, creation and lifetime of Archetypes references."
HOMEPAGE="http://plone.org/products/relations/"
SRC_URI="http://plone.org/products/relations/releases/${PV}/${MY_P}-tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

RDEPEND="net-zope/archetypes"

ZPROD_LIST="Relations"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	# this has to be done manually since $A is incorrect, and readonly
	# unpack function does not work either
	#
	# reviewed (grudgingly) by masterdriverz pending a mail I sent to upstream
	# requesting they fix their tarball names
	tar xzf "${DISTDIR}/${MY_P}-tar.gz" -C "${WORKDIR}" || die 'unpack failed'
}
