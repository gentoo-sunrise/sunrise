# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

inherit eutils java-pkg-2 versionator multilib toolchain-funcs

MY_PN="OpenFOAM"
MY_PV=$(get_version_component_range 1-3 ${PV})
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="OpenFOAM - Utilities"
HOMEPAGE="http://www.opencfd.co.uk/openfoam/"
SRC_URI="mirror://sourceforge/foam/${MY_P}.General.gtgz
	http://dev.gentooexperimental.org/~tommy/distfiles/${P}.patch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="!=sci-libs/openfoam-${MY_PV}*
	!=sci-libs/openfoam-bin-${MY_PV}*
	=dev-java/sun-java3d-bin-1.4*
	<virtual/jdk-1.5
	=sci-libs/openfoam-kernel-${MY_PV}*
	sci-libs/parmetis"

S=${WORKDIR}/${MY_P}
INSDIR=/usr/$(get_libdir)/${MY_PN}/${MY_P}

pkg_setup() {
	if ! version_is_at_least 4.1 $(gcc-version) ; then
		die "${PN} requires >=sys-devel/gcc-4.1 to compile."
	fi

	java-pkg-2_pkg_setup
}

src_unpack() {
	ln -s "${DISTDIR}"/${MY_P}.General.gtgz ${MY_P}.General.tgz
	unpack ./${MY_P}.General.tgz

	cd "${S}"
	epatch "${DISTDIR}"/${P}.patch
	epatch "${FILESDIR}"/${PN}-compile-${PV}.patch
}

src_compile() {
	cp -a "${INSDIR}"/.bashrc "${S}"/.bashrc || "cannot copy .bashrc"
	cp -a "${INSDIR}"/.${MY_P}/bashrc "${S}"/.${MY_P}/bashrc.bak || "cannot copy bashrc.bak"

	use amd64 && export WM_64="on"

	sed -i -e "s|/lib/j3d-org.jar|/lib/j3d-org.jar:/usr/share/sun-java3d-bin/lib/vecmath.jar:/usr/share/sun-java3d-bin/lib/j3dutils.jar:/usr/share/sun-java3d-bin/lib/j3dcore.jar|"	\
		"${S}"/applications/utilities/mesh/manipulation/patchTool/Java/Allwmake

	sed -i -e "s|:../lib/j3d-org.jar|:../lib/j3d-org.jar:/usr/share/sun-java3d-bin/lib/vecmath.jar:/usr/share/sun-java3d-bin/lib/j3dutils.jar:/usr/share/sun-java3d-bin/lib/j3dcore.jar|"	\
		"${S}"/applications/utilities/mesh/manipulation/patchTool/Java/Make/options

	sed -i -e "s|-lmetis \\\|-lmetis|"	\
	-e 's|../metis-5.0pre2/include|/usr/include/metis|'	\
	-e 's|-lGKlib||'	\
	"${S}"/applications/utilities/parallelProcessing/decompositionMethods/decompositionMethods/Make/options	\
	|| die "could not replace metis options"

	sed -i -e 's|wmake libso metis|# wmake libso metis|'	\
	"${S}"/applications/utilities/parallelProcessing/decompositionMethods/Allwmake	\
	|| die "could not replace metis options"

	sed -i -e 's|wmake libso ParMetis|# wmake libso ParMetis|'	\
	"${S}"/applications/utilities/parallelProcessing/decompositionMethods/parMetisDecomp/Allwmake	\
	|| die "could not replace metis options"

	sed -i -e 's|parMetisDecomp/ParMetis-3.1/ParMETISLib|/usr/include/parmetis|'	\
	"${S}"/applications/utilities/parallelProcessing/decompositionMethods/parMetisDecomp/Make/options	\
	|| die "could not replace metis options"

	sed -i -e "s|WM_PROJECT_INST_DIR=/usr/$(get_libdir)/\$WM_PROJECT|WM_PROJECT_INST_DIR="${WORKDIR}"|"		\
		-e "s|WM_PROJECT_DIR=\$WM_PROJECT_INST_DIR/\$WM_PROJECT-\$WM_PROJECT_VERSION|WM_PROJECT_DIR="${S}"|"	\
		"${S}"/.${MY_P}/bashrc.bak || die "could not replace source options"

	sed -i -e "s|\$WM_PROJECT_INST_DIR/\$WM_ARCH/bin|"${INSDIR}"/bin|"	\
		-e "s|FOAM_LIB=\$WM_PROJECT_DIR/lib|FOAM_LIB="${INSDIR}"/lib|"	\
		-e "s|FOAM_LIBBIN=\$FOAM_LIB|FOAM_LIBBIN=\$WM_PROJECT_DIR/lib/\$WM_OPTIONS|"	\
		-e "s|AddLib \$FOAM_USER_LIBBIN|AddLib \$FOAM_LIB|"	\
		-e "s|applications/bin|applications/bin/\$WM_OPTIONS|"	\
		-e "s|FOAM_MPI_LIBBIN=\$FOAM_LIBBIN/|FOAM_MPI_LIBBIN="${INSDIR}"/lib/|"	\
		"${S}"/.bashrc || die "could not replace paths"

	sed -i -e "s|-L\$(LIB_WM_OPTIONS_DIR)|-L\$(LIB_WM_OPTIONS_DIR) -L${INSDIR}/lib|" \
		"${S}"/wmake/Makefile || die "could not replace search paths"

	source "${S}"/.${MY_P}/bashrc.bak

	cd "${S}"/applications/utilities
	wmake all || die "could not build OpenFOAM utilities"
	rm "${S}"/applications/utilities/mesh/conversion/ccm26ToFoam/libccmio/config/{irix64_6.5-mips4,irix_6.5-mips3,sunos64_5.8-ultra,linux64_2.6-pwr4-glibc_2.3.3}/qmake
}

src_install() {
	insopts -m0755
	insinto /usr/$(get_libdir)/${MY_PN}/${MY_P}/applications/bin
	doins -r applications/bin/${WM_OPTIONS}/*

	insinto /usr/$(get_libdir)/${MY_PN}/${MY_P}/lib
	doins -r lib/${WM_OPTIONS}/*

	find "${S}"/applications -type d \( -name "${WM_OPTIONS}" -o -name linuxDebug -o -name linuxOpt \)  | xargs rm -rf

	insopts -m0644
	insinto /usr/$(get_libdir)/${MY_PN}/${MY_P}/applications
	doins -r applications/test applications/utilities
}
