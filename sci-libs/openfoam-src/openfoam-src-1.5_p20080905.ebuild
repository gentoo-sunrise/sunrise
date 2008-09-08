# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

inherit eutils versionator multilib

MY_PN="OpenFOAM"
MY_PV=$(get_version_component_range 1-2)
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="OpenFOAM - sources"
HOMEPAGE="http://www.opencfd.co.uk/openfoam/"
SRC_URI="mirror://sourceforge/foam/${MY_P}.General.gtgz
	http://omploader.org/vcWF0/${P}.patch"

LICENSE="GPL-2"
SLOT="1.5"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="|| ( =sci-libs/openfoam-meta-${MY_PV}* =sci-libs/openfoam-${MY_PV}* =sci-libs/openfoam-bin-${MY_PV}* )"

S=${WORKDIR}/${MY_P}

src_unpack() {
	ln -s "${DISTDIR}"/${MY_P}.General.gtgz ${MY_P}.General.tgz
	unpack ./${MY_P}.General.tgz

	cd "${S}"
	epatch "${FILESDIR}"/${MY_P}-compile.patch

	epatch "${DISTDIR}"/${P}.patch
}

src_install() {
	insinto /usr/$(get_libdir)/${MY_PN}/${MY_P}/src
	doins -r src/*

	insinto /usr/$(get_libdir)/${MY_PN}/${MY_P}/applications
	doins -r applications/*
}
