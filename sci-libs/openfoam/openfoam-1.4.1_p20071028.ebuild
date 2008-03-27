# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

inherit eutils java-pkg-2 versionator python multilib toolchain-funcs

MY_PN="OpenFOAM"
MY_PV=$(get_version_component_range 1-3 ${PV})
MY_P="${MY_PN}-${MY_PV}"
MY_PARA_PV="2.6.2"
MY_PARA_PV_SHORT=$(get_version_component_range 1-2 ${MY_PARA_PV})

DESCRIPTION="Open Field Operation and Manipulation - CFD Simulation Toolbox"
HOMEPAGE="http://www.opencfd.co.uk/openfoam/"
SRC_URI="mirror://sourceforge/foam/${MY_P}.General.gtgz
	parafoam? ( http://www.paraview.org/files/v${MY_PARA_PV_SHORT}/ParaView-${MY_PARA_PV}.tar.gz )
	http://dev.gentooexperimental.org/~jokey/sunrise-dist/${PN}-1.4.1-patches-0.1.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples lam mpich metis parafoam hdf5 mpi python threads"

RDEPEND="!sci-libs/openfoam-bin
	!sci-libs/openfoam-kernel
	!sci-libs/openfoam-meta
	!sci-libs/openfoam-solvers
	!sci-libs/openfoam-utilities
	!sci-libs/openfoam-wmake
	dev-java/sun-java3d-bin
	net-misc/openssh
	net-misc/mico
	<virtual/jdk-1.5
	!mpich? ( !lam? ( sys-cluster/openmpi ) )
	lam? ( sys-cluster/lam-mpi )
	mpich? ( sys-cluster/mpich2 )
	metis? ( sci-libs/metis sci-libs/metis sci-libs/parmetis )
	parafoam? ( sci-libs/vtk
		=sci-visualization/paraview-${MY_PARA_PV} )
	!parafoam? ( <sci-visualization/paraview-3.0 )"

DEPEND="${RDEPEND}
	parafoam? ( dev-util/cmake dev-libs/expat )"

PVSOURCEDIR="${WORKDIR}/paraview-${MY_PARA_PV}"
S=${WORKDIR}/${MY_P}

pkg_setup() {
	if ! version_is_at_least 4.1 $(gcc-version) ; then
		die "${PN} requires >=sys-devel/gcc-4.1 to compile."
	fi

	if use parafoam ; then
		elog
		elog " You are building OpenFOAM with parafoam enabled, this means "
		elog " that you are only building the vtkFoam and PVFoamReader libraries. "
		elog " It is highly recommended to *DISABLE* this USE-Flag and use instead "
		elog " the native OpenFOAM support in ParaView-${MY_PARA_PV}: "
		elog " You have to open the controlDict file of each case and "
		elog " choose the OpenFOAM filter for the controlDict files. "
	else
		elog
		elog " You are building with parafoam disabled, this means "
		elog " that paraFoam will not be installed. "
		elog " You have to use instead the native OpenFOAM support in ParaView-${MY_PARA_PV}: "
		elog " You have to open the controlDict file of each case and "
		elog " choose the OpenFOAM filter for the controlDict files. "
	fi

	if use amd64 ; then
		elog
		elog " In order to use OpenFOAM you should add the following lines to ~/.bashrc :"
		elog ' WM_64="on"'
		elog " source /usr/$(get_libdir)/OpenFOAM/bashrc"
	else
		elog
		elog " In order to use OpenFOAM you should add the following line to ~/.bashrc :"
		elog " source /usr/$(get_libdir)/OpenFOAM/bashrc"
	fi

	elog
	elog " In order to get FoamX running, you have to do the following: "
	elog " mkdir -p ~/.${MY_P}/apps "
	elog " cp -r /usr/$(get_libdir)/${MY_PN}/${MY_P}/.${MY_P}/apps/FoamX ~/.${MY_P}/apps "
	elog

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
	epatch "${WORKDIR}"/patch/${P}.patch
	epatch "${WORKDIR}"/patch/compile-${MY_PV}.patch
	epatch "${WORKDIR}"/patch/mico-${MY_PV}.patch
}

src_compile() {
	use amd64 && export WM_64="on"

	if use lam ; then
		export WM_MPLIB=LAM
	elif use mpich ; then
		export WM_MPLIB=MPICH
	else
		export WM_MPLIB=OPENMPI
	fi

	sed -i -e "s|WM_PROJECT_VERSION=|WM_PROJECT_VERSION=${MY_PV} #|"	\
		-e "s|export WM_PROJECT_INST_DIR=\$HOME/\$WM_PROJECT|# export WM_PROJECT_INST_DIR=\$HOME/\$WM_PROJECT|"	\
		-e "s|#export WM_PROJECT_INST_DIR=/usr/local/\$WM_PROJECT|export WM_PROJECT_INST_DIR=/usr/$(get_libdir)/\$WM_PROJECT|"	\
		-e "s|WM_COMPILER=Gcc|WM_COMPILER=|"	\
		-e "s|[^#]export WM_MPLIB=| #export WM_MPLIB=|"	\
		-e "s|#export WM_MPLIB=$|export WM_MPLIB="${WM_MPLIB}"|" \
		-e "s|SOURCE \$WM_PROJECT_DIR/\$FOAM_DOT_DIR/apps|#SOURCE \$WM_PROJECT_DIR/\$FOAM_DOT_DIR/apps|"	\
			"${S}"/.${MY_P}/bashrc

	sed -i -e "s|WM_PROJECT_VERSION |WM_PROJECT_VERSION ${MY_PV} #|"	\
		-e "s|setenv WM_PROJECT_INST_DIR \$HOME/\$WM_PROJECT|# setenv WM_PROJECT_INST_DIR \$HOME/\$WM_PROJECT|"	\
		-e "s|#setenv WM_PROJECT_INST_DIR /usr/local/\$WM_PROJECT|setenv WM_PROJECT_INST_DIR /usr/$(get_libdir)/\$WM_PROJECT|"	\
		-e "s|WM_COMPILER Gcc|WM_COMPILER |"	\
		-e "s|[^#]setenv WM_MPLIB | #setenv WM_MPLIB |"	\
		-e "s|#setenv WM_MPLIB OPENMPI$|setenv WM_MPLIB "${WM_MPLIB}"|" \
		-e "s|SOURCE \$WM_PROJECT_DIR/\$FOAM_DOT_DIR/apps|#SOURCE \$WM_PROJECT_DIR/\$FOAM_DOT_DIR/apps|"	\
			"${S}"/.${MY_P}/cshrc

	sed -i -e "s|FOAM_JOB_DIR=\$WM_PROJECT_INST_DIR/jobControl|FOAM_JOB_DIR=\$HOME/\$WM_PROJECT/jobControl|"	\
		-e "s|WM_COMPILER_DIR=|WM_COMPILER_DIR=/usr # |"	\
		-e 's|JAVA_HOME=|JAVA_HOME=${JAVA_HOME} # |'	\
		-e 's@OPENMPI_VERSION=@OPENMPI_VERSION=`/usr/bin/ompi_info --version ompi full --parsable | grep ompi:version:full | cut -d: -f4-` # @'	\
		-e 's|[^#]export OPENMPI_HOME=|# export OPENMPI_HOME=|'	\
		-e 's|OPENMPI_ARCH_PATH=|OPENMPI_ARCH_PATH=/usr # |'	\
		-e 's@LAM_VERSION=@LAM_VERSION=`/usr/bin/laminfo -version lam full | awk ''{print \$\$2}''` # @'	\
		-e 's|[^#]export LAMHOME=|# export LAMHOME=|'	\
		-e 's|LAM_ARCH_PATH=|LAM_ARCH_PATH=/usr # |'	\
		-e 's|MPICH_VERSION=|MPICH_VERSION=`/usr/bin/mpich2version --version` # |'	\
		-e 's|[^#]export MPICH_PATH=$FOAM_SRC|# export MPICH_PATH=$FOAM_SRC|'	\
		-e 's|MPICH_ARCH_PATH=|MPICH_ARCH_PATH=/usr # |'	\
			"${S}"/.bashrc

	sed -i -e "s|FOAM_JOB_DIR \$WM_PROJECT_INST_DIR/jobControl|FOAM_JOB_DIR \$HOME/\$WM_PROJECT/jobControl|"	\
		-e "s|WM_COMPILER_DIR |WM_COMPILER_DIR /usr # |"	\
		-e 's|JAVA_HOME |JAVA_HOME ${JAVA_HOME} # |'	\
		-e 's@OPENMPI_VERSION @OPENMPI_VERSION `/usr/bin/ompi_info --version ompi full --parsable | grep ompi:version:full | cut -d: -f4-` # @'	\
		-e 's|[^#]setenv OPENMPI_HOME|# setenv OPENMPI_HOME|'	\
		-e 's|OPENMPI_ARCH_PATH |OPENMPI_ARCH_PATH /usr # |'	\
		-e 's@LAM_VERSION @LAM_VERSION `/usr/bin/laminfo -version lam full | awk ''{print \$\$2}''` # @'	\
		-e 's|[^#]setenv LAMHOME|# setenv LAMHOME|'	\
		-e 's|LAM_ARCH_PATH |LAM_ARCH_PATH /usr # |'	\
		-e 's|MPICH_VERSION |MPICH_VERSION `/usr/bin/mpich2version --version` # |'	\
		-e 's|[^#]setenv MPICH_PATH $FOAM_SRC|# setenv MPICH_PATH $FOAM_SRC|'	\
		-e 's|MPICH_ARCH_PATH |MPICH_ARCH_PATH /usr # |'	\
			"${S}"/.cshrc

	sed -i -e "s|/lib/j3d-org.jar|/lib/j3d-org.jar:/usr/share/sun-java3d-bin/lib/vecmath.jar:/usr/share/sun-java3d-bin/lib/j3dutils.jar:/usr/share/sun-java3d-bin/lib/j3dcore.jar|"	\
		"${S}"/applications/utilities/mesh/manipulation/patchTool/Java/Allwmake

	sed -i -e "s|:../lib/j3d-org.jar|:../lib/j3d-org.jar:/usr/share/sun-java3d-bin/lib/vecmath.jar:/usr/share/sun-java3d-bin/lib/j3dutils.jar:/usr/share/sun-java3d-bin/lib/j3dcore.jar|"	\
		"${S}"/applications/utilities/mesh/manipulation/patchTool/Java/Make/options

	index=`grep -n "CMAKE_HOME/bin:" "${S}"/."${MY_P}"/apps/paraview/bashrc | cut -d ':' -f 1,1`
	index1=$((${index}-1))
	index2=$((${index}+1))
	sed -i -e "s|CMAKE_HOME=|CMAKE_HOME=/usr # |"	\
		-e "${index1}{s|[^#]|# i|}"	\
		-e "${index2}{s|[^#]|# f|}"	\
		-e "s|[^#]export PATH=\$CMAKE_HOME/|# export PATH=\$CMAKE_HOME/|"	\
		-e "s|ParaView_VERSION=|ParaView_VERSION=${MY_PARA_PV} # |"	\
		-e "s|ParaView_INST_DIR=\$WM_PROJECT_INST_DIR/\$WM_ARCH/paraview-\$ParaView_VERSION|ParaView_INST_DIR=/usr|"	\
		-e "s|\$ParaView_INST_DIR/lib/paraview-2.4|\$ParaView_INST_DIR/lib/ParaView-${MY_PARA_PV_SHORT}|"	\
		-e "s|[^#]export PATH=\$ParaView_INST_DIR|# export PATH=\$ParaView_INST_DIR|"	\
		-e "s|[^#]export LD_LIBRARY_PATH=|# export LD_LIBRARY_PATH=|"	\
			"${S}"/."${MY_P}"/apps/paraview/bashrc

	index=`grep -n "CMAKE_HOME/bin" "${S}"/."${MY_P}"/apps/paraview/cshrc | cut -d ':' -f 1,1`
	index1=$((${index}-1))
	index2=$((${index}+1))
	sed -i -e "s|CMAKE_HOME |CMAKE_HOME /usr # |"	\
		-e "${index1}{s|[^#]|# i|}"	\
		-e "${index2}{s|[^#]|# f|}"	\
		-e "s|[^#]set path=(\$CMAKE_HOME/|# set path=(\$CMAKE_HOME/|"	\
		-e "s|ParaView_VERSION |ParaView_VERSION ${MY_PARA_PV} # |"	\
		-e "s|ParaView_INST_DIR \$WM_PROJECT_INST_DIR/\$WM_ARCH/paraview-\$ParaView_VERSION|ParaView_INST_DIR /usr|"	\
		-e "s|\$ParaView_INST_DIR/lib/paraview-2.4|\$ParaView_INST_DIR/lib/ParaView-${MY_PARA_PV_SHORT}|"	\
		-e "s|[^#]set path=(\$ParaView_INST_DIR|# set path=(\$ParaView_INST_DIR|"	\
		-e "s|[^#]setenv LD_LIBRARY_PATH|# setenv LD_LIBRARY_PATH|"	\
			"${S}"/."${MY_P}"/apps/paraview/cshrc

	sed -i -e 's|MICO_VERSION=|MICO_VERSION=`/usr/bin/mico-config --version` # |'	\
		-e "s|[^#]export MICO_PATH=|# export MICO_PATH=|"	\
		-e "s|MICO_ARCH_PATH=|MICO_ARCH_PATH=/usr # |"	\
		"${S}"/.bashrc

	sed -i -e 's|MICO_VERSION |MICO_VERSION `/usr/bin/mico-config --version` # |'	\
		-e "s|[^#]setenv MICO_PATH |# setenv MICO_PATH |"	\
		-e "s|MICO_ARCH_PATH |MICO_ARCH_PATH /usr # |"	\
		"${S}"/.cshrc

	if use metis ; then
		sed -i -e "s|-lmetis \\\|-L/usr/$(get_libdir) -lmetis|"	\
		-e 's|../metis-5.0pre2/include|/usr/include|'	\
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
		-e 's|parMetisDecomp/ParMetis-3.1|/usr/include|'	\
		-e "s|-lmetis|-L/usr/$(get_libdir) -lMETIS -lmetis|"	\
		-e "s|-lparmetis|-L/usr/$(get_libdir) -lparmetis|"	\
		"${S}"/applications/utilities/parallelProcessing/decompositionMethods/parMetisDecomp/Make/options	\
		|| die "could not replace metis options"
	fi

	cp "${S}"/.${MY_P}/bashrc "${S}"/.${MY_P}/bashrc.bak

	sed -i -e "s|WM_PROJECT_INST_DIR=/usr/lib/\$WM_PROJECT|WM_PROJECT_INST_DIR="${WORKDIR}"|"		\
		-e "s|WM_PROJECT_DIR=\$WM_PROJECT_INST_DIR/\$WM_PROJECT-\$WM_PROJECT_VERSION|WM_PROJECT_DIR="${S}"|"	\
		"${S}"/.${MY_P}/bashrc.bak	\
		|| die "could not replace source options"

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

		sed -i -e "s|#SOURCE \$WM_PROJECT_DIR/\$FOAM_DOT_DIR/apps/paraview|SOURCE \$WM_PROJECT_DIR/\$FOAM_DOT_DIR/apps/paraview|"	\
		"${S}"/.${MY_P}/bashrc	\
		|| die "could not replace source options"

		sed -i -e "s|#SOURCE \$WM_PROJECT_DIR/\$FOAM_DOT_DIR/apps/paraview/bashrc|SOURCE \$WM_PROJECT_DIR/\$FOAM_DOT_DIR/apps/paraview/bashrc.bak|"	\
		"${S}"/.${MY_P}/bashrc.bak	\
		|| die "could not replace source options"

		sed -i -e "s|/include|/include/vtk-5.0|"	\
			"${S}"/applications/utilities/postProcessing/graphics/PVFoamReader/vtkFoam/Make/options

		cp "${S}"/.${MY_P}/apps/paraview/bashrc "${S}"/.${MY_P}/apps/paraview/bashrc.bak

		sed -i -e "s|ParaView_DIR=\$ParaView_INST_DIR/lib/ParaView-2.6|ParaView_DIR="${WORKDIR}"/paraview-${MY_PARA_PV}-obj|"	\
		"${S}"/.${MY_P}/apps/paraview/bashrc.bak	\
		|| die "could not replace source options"
	fi

	. "${S}"/.${MY_P}/bashrc.bak

	cd "${S}"/wmake/rules
	ln -sf ${WM_ARCH}Gcc $WM_ARCH${WM_COMPILER} || die "dosym wmake linuxXX failed"

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
	doins -r .bashrc .cshrc .${MY_P}

	use examples && doins -r tutorials

	insopts -m0755
	doins -r bin
	insinto /usr/$(get_libdir)/${MY_PN}/${MY_P}/applications/bin
	doins -r applications/bin/${WM_OPTIONS}/*

	insinto /usr/$(get_libdir)/${MY_PN}/${MY_P}/lib
	doins -r lib/${WM_OPTIONS}/*

	insinto /usr/$(get_libdir)/${MY_PN}/${MY_P}/wmake
	doins -r wmake/*

	insopts -m0644
	find "${S}"/applications -type d \( -name "${WM_OPTIONS}" -o -name linuxDebug -o -name linuxOpt \)  | xargs rm -rf

	insinto /usr/$(get_libdir)/${MY_PN}/${MY_P}/applications
	doins -r applications/solvers applications/test applications/utilities

	insinto /usr/share/${MY_PN}/${MY_P}/doc
	doins -r README doc/Guides-a4 doc/Guides-usletter

	dosym /usr/$(get_libdir)/${MY_PN}/${MY_P}/.${MY_P}/bashrc /usr/$(get_libdir)/${MY_PN}/bashrc
	dosym /usr/$(get_libdir)/${MY_PN}/${MY_P}/.${MY_P}/cshrc /usr/$(get_libdir)/${MY_PN}/cshrc
}
