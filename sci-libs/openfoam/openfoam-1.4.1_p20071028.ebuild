# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

inherit eutils java-pkg-2 versionator python multilib toolchain-funcs

MY_PN="OpenFOAM"
MY_PV=$(get_version_component_range 1-3 ${PV})
MY_P="${MY_PN}-${MY_PV}"
MY_PARA_PV="2.6.2"

DESCRIPTION="Open Field Operation and Manipulation - CFD Simulation Toolbox"
HOMEPAGE="http://www.opencfd.co.uk/openfoam/"
SRC_URI="mirror://sourceforge/foam/${MY_P}.General.gtgz
	parafoam? ( http://www.paraview.org/files/v2.6/ParaView-${MY_PARA_PV}.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples lam mico mpich parafoam hdf5 mpi python threads"

RDEPEND="dev-java/sun-java3d-bin
	net-misc/openssh
	mico? ( net-misc/mico )
	sys-libs/readline
	sys-libs/zlib
	<virtual/jdk-1.5
	!mpich? ( !lam? ( sys-cluster/openmpi ) )
	lam? ( sys-cluster/lam-mpi )
	mpich? ( sys-cluster/mpich2 )
	parafoam? ( sci-libs/vtk
		=sci-visualization/paraview-${MY_PARA_PV} )
	!parafoam? ( sci-visualization/paraview )"

DEPEND="${RDEPEND}
	parafoam? ( dev-util/cmake dev-libs/expat )"

PVSOURCEDIR="${WORKDIR}/paraview-${MY_PARA_PV}"
S=${WORKDIR}/${MY_P}

pkg_setup() {
	if [[ $(gcc-major-version) -lt 4 && $(gcc-minor-version) -lt 1 ]] ; then
		die "${PN} requires >=sys-devel/gcc-4.1 to compile."
	fi

	if use parafoam ; then
		ewarn
		ewarn " You are building OpenFOAM with parafoam enabled, this means "
		ewarn " that you are only building the vtkFoam and PVFoamReader libraries. "
		ewarn " It is highly recommended to *DISABLE* this USE-Flag and use instead "
		ewarn " the native OpenFOAM support in ParaView-${MY_PARA_PV}: "
		ewarn " You have to open the controlDict file of each case and "
		ewarn " choose the OpenFOAM filter for the controlDict files. "
		ewarn
	else
		ewarn
		ewarn " You are building with parafoam enabled, this means "
		ewarn " that paraFoam will not be installed. "
		ewarn " You have to use instead the native OpenFOAM support in ParaView-${MY_PARA_PV}: "
		ewarn " You have to open the controlDict file of each case and "
		ewarn " choose the OpenFOAM filter for the controlDict files. "
		ewarn
	fi

	if ! use mico ; then
		ewarn
		ewarn " You are building OpenFOAM without the mico USE-Flag, that means "
		ewarn " you build against the mico that is shipped with OpenFOAM. "
		ewarn " It is highly recommended to enable the mico USE-Flag and "
		ewarn " build against a system wide mico. "
		ewarn " At the moment there is no mico ebuild in the official portage tree, "
		ewarn " but Bug 122141 provides an working ebuild. "
		ewarn
	fi

	java-pkg-2_pkg_setup
}

src_unpack() {
	ln -s "${DISTDIR}"/${MY_P}.General.gtgz ${MY_P}.General.tgz
	unpack ./${MY_P}.General.tgz

	if use parafoam ; then
		unpack ParaView-${MY_PARA_PV}.tar.gz
		cd "${WORKDIR}"
		mv ParaView-${MY_PARA_PV} paraview-${MY_PARA_PV}
		mkdir paraview-${MY_PARA_PV}-obj
	fi

	cd "${S}"
	epatch "${FILESDIR}"/${P}.patch || die "could not patch"
	epatch "${FILESDIR}"/compile-${MY_PV}.patch || die "could not patch"

	use mico && epatch "${FILESDIR}"/mico-${MY_PV}.patch
}

src_compile() {
	if use amd64 ; then
		export WM_64="on"
	fi

	if use parafoam ; then
		cd "${WORKDIR}"/paraview-${MY_PARA_PV}-obj

		local CMAKE_VARIABLES=""
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DCMAKE_BACKWARDS_COMPATIBILITY=2.2"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DPV_INSTALL_LIB_DIR:PATH=/usr/$(get_libdir)/ParaView-2.6/"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DCMAKE_SKIP_RPATH:BOOL=YES"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_RPATH:BOOL=NO"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DCMAKE_INSTALL_PREFIX:PATH=/usr"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DBUILD_SHARED_LIBS:BOOL=ON"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_SYSTEM_FREETYPE:BOOL=ON"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_SYSTEM_JPEG:BOOL=ON"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_SYSTEM_PNG:BOOL=ON"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_SYSTEM_TIFF:BOOL=ON"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_SYSTEM_ZLIB:BOOL=ON"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_SYSTEM_EXPAT:BOOL=ON"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DEXPAT_INCLUDE_DIR:PATH=/usr/include"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DEXPAT_LIBRARY=/usr/$(get_libdir)/libexpat.so"

		if use hdf5; then
			CMAKE_VARIABLES="${CMAKE_VARIABLES} -DPARAVIEW_USE_SYSTEM_HDF5:BOOL=ON"
		fi

		if use mpi; then
			CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_MPI:BOOL=ON"
		fi

		if use python; then
			python_version
			CMAKE_VARIABLES="${CMAKE_VARIABLES} -DPARAVIEW_WRAP_PYTHON:BOOL=ON"
			CMAKE_VARIABLES="${CMAKE_VARIABLES} -DPYTHON_INCLUDE_PATH:PATH=/usr/include/python${PYVER}"
			CMAKE_VARIABLES="${CMAKE_VARIABLES} -DPYTHON_LIBRARY:PATH=/usr/$(get_libdir)/libpython${PYVER}.so"
		fi

		use doc && CMAKE_VARIABLES="${CMAKE_VARIABLES} -DBUILD_DOCUMENTATION:BOOL=ON"

		if use examples; then
			CMAKE_VARIABLES="${CMAKE_VARIABLES} -DBUILD_EXAMPLES:BOOL=ON"
		else
			CMAKE_VARIABLES="${CMAKE_VARIABLES} -DBUILD_EXAMPLES:BOOL=OFF"
		fi

		if use threads; then
			CMAKE_VARIABLES="${CMAKE_VARIABLES} -DCMAKE_USE_PTHREADS:BOOL=ON"
		else
			CMAKE_VARIABLES="${CMAKE_VARIABLES} -DCMAKE_USE_PTHREADS:BOOL=OFF"
		fi

		cmake ${CMAKE_VARIABLES} ${PVSOURCEDIR}
		cp /usr/lib/ParaView-2.6/{libvtkClientServer.*,libverdict112.*,libvtkGraphicsCS.*,libvtkFilteringCS.*,libvtkCommonCS.*} bin/. || die "could not copy"

		emake vtkWrapClientServer
	fi

	if use lam ; then
		export WM_MPLIB=LAM
	elif use mpich ; then
		export WM_MPLIB=MPICH
	else
		export WM_MPLIB=OPENMPI
	fi

	sed -i -e "s|[^#]export WM_MPLIB| #export WM_MPLIB|"	\
		-e "s|#export WM_MPLIB=OPENMPI|export WM_MPLIB="${WM_MPLIB}"|"	\
		"${S}"/.${MY_P}/bashrc || die "could not replace bashrc"

	sed -i -e "s|[^#]setenv WM_MPLIB| #setenv WM_MPLIB|"	\
		-e "s|#setenv WM_MPLIB OPENMPI|setenv WM_MPLIB "${WM_MPLIB}"|"	\
		"${S}"/.${MY_P}/cshrc || die "could not replace cshrc"

	cp "${S}"/.${MY_P}/bashrc "${S}"/.${MY_P}/bashrc.bak

	sed -i -e "s|WM_PROJECT_INST_DIR=/usr/lib/\$WM_PROJECT|WM_PROJECT_INST_DIR="${WORKDIR}"|"		\
		-e "s|WM_PROJECT_DIR=\$WM_PROJECT_INST_DIR/\$WM_PROJECT-\$WM_PROJECT_VERSION|WM_PROJECT_DIR="${S}"|"	\
		"${S}"/.${MY_P}/bashrc.bak	\
		|| die "could not replace source options"

	if use parafoam ; then
		sed -i -e "s|#SOURCE \$WM_PROJECT_DIR/\$FOAM_DOT_DIR/apps/paraview/bashrc|SOURCE \$WM_PROJECT_DIR/\$FOAM_DOT_DIR/apps/paraview/bashrc.bak|"	\
		"${S}"/.${MY_P}/bashrc.bak	\
		|| die "could not replace source options"

		sed -i -e "s|#SOURCE \$WM_PROJECT_DIR/\$FOAM_DOT_DIR/apps/paraview|SOURCE \$WM_PROJECT_DIR/\$FOAM_DOT_DIR/apps/paraview|"	\
		"${S}"/.${MY_P}/bashrc	\
		|| die "could not replace source options"

		cp "${S}"/.${MY_P}/apps/paraview/bashrc "${S}"/.${MY_P}/apps/paraview/bashrc.bak

		sed -i -e "s|ParaView_DIR=\$ParaView_INST_DIR/lib/ParaView-2.6|ParaView_DIR="${WORKDIR}"/paraview-${MY_PARA_PV}-obj|"	\
		"${S}"/.${MY_P}/apps/paraview/bashrc.bak	\
		|| die "could not replace source options"
	fi

	. "${S}"/.${MY_P}/bashrc.bak

	cd "${S}"/wmake/rules
	ln -sf ${WM_ARCH}Gcc $WM_ARCH${WM_COMPILER} || die "dosym wmake linux64 failed"

	cd "${S}"
	./Allwmake || die "could not build"

	use !parafoam && rm "${S}"/bin/paraFoam*

	rm .${MY_P}/bashrc.bak
	use parafoam && rm .${MY_P}/apps/paraview/bashrc.bak

	sed -i -e "s|/\$WM_OPTIONS||" "${S}"/.bashrc || die "could not delete \$WM_OPTIONS in .bashrc"
	sed -i -e "s|/\$WM_OPTIONS||" "${S}"/.cshrc || die "could not delete \$WM_OPTIONS in .cshrc"
	rm "${S}"/applications/utilities/mesh/conversion/ccm26ToFoam/libccmio/config/{irix64_6.5-mips4,irix_6.5-mips3,sunos64_5.8-ultra,linux64_2.6-pwr4-glibc_2.3.3}/qmake
	rm "${S}"/wmake/rules/$WM_ARCH${WM_COMPILER}
	rm "${S}"/wmake/rules/{solarisGcc,sgi64Gcc,sgiN32Gcc}/dirToString
	rm "${S}"/wmake/rules/{solarisGcc,linuxI64}/wmkdep
}

src_test() {
	cd "${S}"/bin
	./foamInstallationTest
}

src_install() {
	insinto /usr/$(get_libdir)/"${MY_PN}"/${MY_P}
	doins -r .bashrc .cshrc .${MY_P} || die "could not install hidden files and directories"

	if use examples ; then
		doins -r tutorials || die "could not install examples"
	fi

	insopts -m0755
	doins -r bin || die "could not install binaries"
	insinto /usr/$(get_libdir)/${MY_PN}/${MY_P}/applications/bin
	doins -r applications/bin/${WM_OPTIONS}/* || die "could not install applications"

	insinto /usr/$(get_libdir)/${MY_PN}/${MY_P}/lib
	doins -r lib/${WM_OPTIONS}/* || die "could not install libraries"

	insinto /usr/$(get_libdir)/${MY_PN}/${MY_P}/wmake
	doins -r wmake/* || die "could not install wmake"

	insopts -m0644
	find "${S}"/applications -type d \( -name "${WM_OPTIONS}" -o -name linuxDebug -o -name linuxOpt \)  | xargs rm -rf

	insinto /usr/$(get_libdir)/${MY_PN}/${MY_P}/applications
	doins -r applications/solvers applications/test applications/utilities || die "could not install applications"

	if use doc ; then
		insinto /usr/share/${MY_PN}/${MY_P}/doc
		doins -r README doc/Guides-a4 doc/Guides-usletter || die "could not install docs"
	fi

	dosym /usr/$(get_libdir)/${MY_PN}/${MY_P}/.${MY_P}/bashrc /usr/$(get_libdir)/${MY_PN}/bashrc || die "could not make symlink"
}
