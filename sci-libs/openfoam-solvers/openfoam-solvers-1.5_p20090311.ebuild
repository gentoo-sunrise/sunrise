# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI=2

inherit eutils versionator multilib toolchain-funcs

MY_PN="OpenFOAM"
MY_PV=$(get_version_component_range 1-2)
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="OpenFOAM - solvers"
HOMEPAGE="http://www.opencfd.co.uk/openfoam/"
SRC_URI="mirror://sourceforge/foam/${MY_P}.General.gtgz -> ${MY_P}.General.tgz
	http://omploader.org/vMWRlMQ/${MY_P}-git-${PVR}.patch
	http://omploader.org/vMWRlMA/${MY_P}-svn.patch"

LICENSE="GPL-2"
SLOT="1.5"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="!=sci-libs/openfoam-${MY_PV}*
	!=sci-libs/openfoam-bin-${MY_PV}*
	=sci-libs/openfoam-kernel-${MY_PV}*"
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
	epatch "${FILESDIR}"/${MY_P}-compile.patch
	epatch "${DISTDIR}"/${MY_P}-svn.patch
	epatch "${DISTDIR}"/${MY_PN}-git-${PVR}.patch
	epatch "${FILESDIR}"/${MY_P}-ggi.patch
}

src_compile() {
	cp -a ${INSDIR}/etc/{bashrc,settings.sh} etc/. || "cannot copy bashrc"

	# This is a hack, due to the meta ebuild:
	sed -i -e "s|FOAM_LIB=\$WM_PROJECT_DIR/lib|FOAM_LIB=${INSDIR}/lib|"	\
		-e "s|FOAM_LIBBIN=\$FOAM_LIB|FOAM_LIBBIN=\$WM_PROJECT_DIR/lib|"	\
		-e "s|_foamAddLib \$FOAM_USER_LIBBIN|_foamAddLib \$FOAM_LIB|"	\
		etc/settings.sh || die "could not replace paths"

	sed -i -e "s|-L\$(LIB_WM_OPTIONS_DIR)|-L\$(LIB_WM_OPTIONS_DIR) -L${INSDIR}/lib|" \
		wmake/Makefile || die "could not replace search paths"

	export FOAM_INST_DIR="${WORKDIR}"
	source etc/bashrc

	cd applications/solvers
	wmake all || die "could not build OpenFOAM utilities"
}

src_install() {
	insopts -m0755
	insinto ${INSDIR}/applications/bin
	doins -r applications/bin/* || die "doins failed"

	insinto ${INSDIR}/lib
	doins -r lib/* || die "doins failed"
}
