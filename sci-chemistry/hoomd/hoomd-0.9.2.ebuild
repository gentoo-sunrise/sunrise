# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit cmake-utils eutils fdo-mime python versionator
DESCRIPTION="HOOMD performs general purpose molecular dynamics simulations on NVIDIA GPUs"
HOMEPAGE="http://codeblue.umich.edu/hoomd-blue/index.html"
SRC_URI="http://codeblue.umich.edu/hoomd-blue/downloads/0.9/${P}.tar.bz2
	doc? ( http://codeblue.umich.edu/hoomd-blue/downloads/0.9/hoomd-userdoc-${PV}.pdf
		http://codeblue.umich.edu/hoomd-blue/downloads/0.9/hoomd-devdoc-${PV}.tar.bz2 )"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+cuda debug doc +openmp +single-precision static-libs test zlib"

RDEPEND="dev-libs/boost
	cuda? ( >=dev-util/nvidia-cuda-toolkit-2.0 )
	sys-libs/zlib"
DEPEND="${RDEPEND}"
RESTRICT_PYTHON_ABIS="3.*"

pkg_setup() {
	python_pkg_setup

	if use cuda; then
		if has_version '<=dev-util/nvidia-cuda-toolkit-3.0'; then
			if version_is_at_least 4.4 $(gcc-version); then
				ewarn "Nvidia CUDA SDK version 3.0 and below requires a gcc version less than 4.4"
				ewarn "Enabling the cuda use flag with gcc version 4.4 or higher will cause build failures in those SDK versions."
				ewarn "Please use gcc-config to set a gcc version less than 4.4 ."
			fi

		elif has_version '<=dev-util/nvidia-cuda-toolkit-3.2'; then
			if version_is_at_least 4.5 $(gcc-version); then
				ewarn "Nvidia CUDA SDK Version 3.2 and below require a gcc version less than 4.5"
				ewarn "Enabling the cuda use flag with gcc version 4.5 or higher will cause build failures in those SDK versions."
				ewarn "Please use gcc-config to set a gcc version less than 4.5."
			fi
		fi
	fi
}

src_prepare(){
	python_copy_sources
}

src_configure(){
	use single-precision && local sp="ON" || local sp="OFF"

	if use !single-precision && use cuda ; then
		ewarn "Single precision must be enabled to have cuda support built-in."
		ewarn "Single-precision will be enabled for this build."
		local sp="ON"
	fi
	my_config() {
		local mycmakeargs=(
			$(cmake-utils_use_enable cuda CUDA)
			$(cmake-utils_use_enable static-libs STATIC)
			$(cmake-utils_use_enable test BUILD_TESTING)
			$(cmake-utils_use_enable openmp OPENMP)
			$(cmake-utils_use_enable zlib ZLIB)
			-DENABLE_VALGRIND=OFF
			-DENABLE_NATIVE_INSTALL=0N
			-DENABLE_DOXYGEN=OFF
			-DPYTHON_SITEDIR="$(python_get_sitedir)"
			-DENABLE_SINGLE_PRECISION=${sp}
			-DCMAKE_BUILD_TYPE=${cbt}
			-DENABLE_OCELOT:BOOL=OFF
			)

		cmake-utils_src_configure
	}

	python_execute_function -s my_config
}

src_test(){
	python_execute_function -s cmake-utils_src_test
}

src_install(){
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins  hoom-userdoc-${PV}.pdf

		insinto /usr/share/doc/${PF}/devdocs
		doins -r "${WORKDIR}/hoomd-devdoc-${PV}/"
	fi

	python_execute_function -s cmake-utils_src_install
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
