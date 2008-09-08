# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

inherit eutils versionator multilib toolchain-funcs

MY_PN="OpenFOAM"
MY_PV=$(get_version_component_range 1-2)
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="OpenFOAM - kernel"
HOMEPAGE="http://www.opencfd.co.uk/openfoam/"
SRC_URI="mirror://sourceforge/foam/${MY_P}.General.gtgz
	http://omploader.org/vcWFz/${P}.patch"

LICENSE="GPL-2"
SLOT="1.5"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="!=sci-libs/openfoam-${MY_PV}*
	!=sci-libs/openfoam-bin-${MY_PV}*
	=sci-libs/openfoam-wmake-${MY_PV}*
	sci-libs/parmetis
	sci-libs/parmgridgen"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	if ! version_is_at_least 4.1 $(gcc-version) ; then
		die "${PN} requires >=sys-devel/gcc-4.1 to compile."
	fi
}

src_unpack() {
	ln -s "${DISTDIR}"/${MY_P}.General.gtgz ${MY_P}.General.tgz
	unpack ./${MY_P}.General.tgz

	cd "${S}"
	epatch "${FILESDIR}"/${MY_P}-compile.patch

	epatch "${DISTDIR}"/${P}.patch
}

src_compile() {
	cp -a /usr/$(get_libdir)/${MY_PN}/${MY_P}/etc/{bashrc,settings.sh} etc/. || die "cannot copy bashrc"

	export FOAM_INST_DIR="${WORKDIR}"
	source etc/bashrc

	cd src
	./Allwmake || die "could not build OpenFOAM kernel"
}

src_install() {
	insopts -m0755
	insinto /usr/$(get_libdir)/${MY_PN}/${MY_P}/lib
	doins -r lib/*
}
