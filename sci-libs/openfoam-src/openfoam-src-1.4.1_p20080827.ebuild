# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

inherit eutils versionator multilib

MY_PN="OpenFOAM"
MY_PV=$(get_version_component_range 1-3 ${PV})
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="OpenFOAM - Kernel Sources"
HOMEPAGE="http://www.opencfd.co.uk/openfoam/"
SRC_URI="mirror://sourceforge/foam/${MY_P}.General.gtgz
	http://dev.gentooexperimental.org/~tommy/distfiles/${P}.patch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="|| ( =sci-libs/openfoam-meta-${MY_PV}* =sci-libs/openfoam-${MY_PV}* =sci-libs/openfoam-bin-${MY_PV}* )"

S=${WORKDIR}/${MY_P}

src_unpack() {
	ln -s "${DISTDIR}"/${MY_P}.General.gtgz ${MY_P}.General.tgz
	unpack ./${MY_P}.General.tgz

	cd "${S}"
	epatch "${DISTDIR}"/${P}.patch
	epatch "${FILESDIR}"/${PN}-compile-${PV}.patch
}

src_install() {
	rm -rf "${S}"/src/{lam-7.1.2,mico-2.3.12,openmpi-1.2.3,zlib-1.2.1}

	insopts -m0644
	insinto /usr/$(get_libdir)/${MY_PN}/${MY_P}/src
	doins -r src/*
}
