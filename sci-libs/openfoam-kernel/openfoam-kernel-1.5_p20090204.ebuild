# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI=2

inherit eutils versionator multilib toolchain-funcs

MY_PN="OpenFOAM"
MY_PV=$(get_version_component_range 1-2)
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="OpenFOAM - kernel"
HOMEPAGE="http://www.opencfd.co.uk/openfoam/"
SRC_URI="mirror://sourceforge/foam/${MY_P}.General.gtgz -> ${MY_P}.General.tgz
	http://omploader.org/vMTdrZA/${P}.patch"

LICENSE="GPL-2"
SLOT="1.5"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="!=sci-libs/openfoam-${MY_PV}*
	!=sci-libs/openfoam-bin-${MY_PV}*
	=sci-libs/openfoam-wmake-${MY_PV}*
	sci-libs/parmetis
	sci-libs/parmgridgen"
DEPEND="${RDEPEND}
	>=sys-devel/gcc-4.1"

S=${WORKDIR}/${MY_P}
INSDIR="/usr/$(get_libdir)/${MY_PN}/${MY_P}"

pkg_setup() {
	# just to be sure the right profile is selected (gcc-config)
	if ! version_is_at_least 4.1 $(gcc-version) ; then
		die "${PN} requires >=sys-devel/gcc-4.1 to compile."
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${MY_P}-compile.patch"
	epatch "${DISTDIR}/${P}.patch"
}

src_compile() {
	cp -a ${INSDIR}/etc/{bashrc,settings.sh} etc/. || die "cannot copy bashrc"

	export FOAM_INST_DIR="${WORKDIR}"
	source etc/bashrc

	cd src
	./Allwmake || die "could not build OpenFOAM kernel"
}

src_install() {
	insopts -m0755
	insinto ${INSDIR}
	doins -r lib/ || die "doins failed"
}
