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
	http://dev.gentooexperimental.org/~jokey/sunrise-dist/${P}-patches-0.1.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="|| ( sci-libs/openfoam-meta sci-libs/openfoam sci-libs/openfoam-bin )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_unpack() {
	ln -s "${DISTDIR}"/${MY_P}.General.gtgz ${MY_P}.General.tgz
	unpack ./${MY_P}.General.tgz
	unpack "${DISTDIR}"/${P}-patches-0.1.tar.bz2

	cd "${S}"
	epatch "${WORKDIR}"/patch/${P}.patch
	epatch "${WORKDIR}"/patch/${PN}-compile-${PV}.patch
}

src_install() {
	rm -rf "${S}"/src/{lam-7.1.2,mico-2.3.12,openmpi-1.2.3,zlib-1.2.1}

	insopts -m0644
	insinto /usr/$(get_libdir)/${MY_PN}/${MY_P}/src
	doins -r src/*
}
