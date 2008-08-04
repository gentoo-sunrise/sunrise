# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

inherit eutils versionator multilib toolchain-funcs

MY_PN="OpenFOAM"
MY_PV=$(get_version_component_range 1-2)
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Open Field Operation and Manipulation - CFD Simulation Toolbox"
HOMEPAGE="http://www.opencfd.co.uk/openfoam/"
SRC_URI="mirror://sourceforge/foam/${MY_P}.General.gtgz
	x86? ( mirror://sourceforge/foam/${MY_P}.linuxGccDPOpt.gtgz )
	amd64? ( mirror://sourceforge/foam/${MY_P}.linux64GccDPOpt.gtgz )"

LICENSE="GPL-2"
SLOT="1.5"
KEYWORDS="-* ~amd64 ~x86"
IUSE="examples doc"

DEPEND="!=sci-libs/openfoam-${MY_PV}*
	!=sci-libs/openfoam-kernel-${MY_PV}*
	!=sci-libs/openfoam-meta-${MY_PV}*
	!=sci-libs/openfoam-solvers-${MY_PV}*
	!=sci-libs/openfoam-utilities-${MY_PV}*
	!=sci-libs/openfoam-wmake-${MY_PV}*
	|| ( >sci-visualization/paraview-3.0 sci-visualization/opendx )
	virtual/mpi"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	if ! version_is_at_least 4.2 $(gcc-version) ; then
		die "${PN} requires >=sys-devel/gcc-4.2 to compile."
	fi

	elog
	elog "In order to use ${MY_PN} you should add the following line to ~/.bashrc :"
	elog "source /usr/$(get_libdir)/${MY_PN}/bashrc"
	ewarn
	ewarn "FoamX is deprecated since ${MY_PN}-1.5! "
	ewarn

	use x86 && WM_OPTIONS="linuxGccDPOpt"
	use amd64 && WM_OPTIONS="linux64GccDPOpt"
}

src_unpack() {
	ln -s "${DISTDIR}"/${MY_P}.General.gtgz ${MY_P}.General.tgz
	unpack ./${MY_P}.General.tgz

	use x86 && ln -s "${DISTDIR}"/${MY_P}.linuxGccDPOpt.gtgz ${MY_P}.binary.tgz
	use amd64 && ln -s "${DISTDIR}"/${MY_P}.linux64GccDPOpt.gtgz ${MY_P}.binary.tgz
	unpack ./${MY_P}.binary.tgz

	cd "${S}"
	epatch "${FILESDIR}"/${MY_P}-compile.patch
}

src_compile() {
	if has_version sys-cluster/lam-mpi ; then
		export WM_MPLIB=LAM
		export MPI_VERSION=lam
	elif has_version sys-cluster/mpich2 ; then
		export WM_MPLIB=MPICH
		export MPI_VERSION=mpich
	elif has_version sys-cluster/openmpi ; then
		export WM_MPLIB=OPENMPI
		export MPI_VERSION=openmpi
	else
		die "You need one of the following mpi implementations: openmpi, lam-mpi or mpich2"
	fi

	sed -i -e "s|WM_MPLIB:=OPENMPI|WM_MPLIB:="${WM_MPLIB}"|" etc/bashrc
	sed -i -e "s|setenv WM_MPLIB OPENMPI|setenv WM_MPLIB "${WM_MPLIB}"|" etc/cshrc

	mv lib/${WM_OPTIONS}/$MPI_VERSION* lib/${WM_OPTIONS}/$MPI_VERSION
}

src_test() {
	cd bin
	./foamInstallationTest
}

src_install() {
	insinto /usr/$(get_libdir)/${MY_PN}/${MY_P}
	doins -r etc

	rm -rf tutorials/rhoPorousSimpleFoam/angledDuctExplicit/{0,constant}
	cp -a tutorials/rhoPorousSimpleFoam/angledDuctImplicit/{0,constant} tutorials/rhoPorousSimpleFoam/angledDuctExplicit
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
	insinto /usr/share/doc/${PF}
	doins doc/Guides-a4/*.pdf
	dodoc README

	if use doc ; then
		dohtml -r doc/Doxygen
	fi

	dosym /usr/$(get_libdir)/${MY_PN}/${MY_P}/etc/bashrc /usr/$(get_libdir)/${MY_PN}/bashrc
	dosym /usr/$(get_libdir)/${MY_PN}/${MY_P}/etc/cshrc /usr/$(get_libdir)/${MY_PN}/cshrc
}
