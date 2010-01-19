# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit multilib toolchain-funcs versionator

MY_PV="$(get_version_component_range 1-2)"
DESCRIPTION="Library of C++ utilities with evil buildsystem"
HOMEPAGE="http://codesynthesis.com/projects/libcutl/"
SRC_URI="http://codesynthesis.com/download/${PN}/${MY_PV}/${P}.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# dev-zero's overlay has an old, incompatible version of build-0.3.3
DEPEND=">=dev-util/build-0.3.5:0.3"
RDEPEND=""

src_prepare() {
	mkdir -p build/cxx/gnu || die
	echo "cxx_id := gnu" >> build/cxx/configuration-dynamic.make || die

	echo "cxx_gnu := $(tc-getCXX)" >> build/cxx/gnu/configuration-dynamic.make || die
	echo "cxx_gnu_optimization_options := ${CXXFLAGS}" >> build/cxx/gnu/configuration-dynamic.make || die

	mkdir -p build/ld || die
	echo "ld_lib_type := shared" >> build/ld/configuration-lib-dynamic.make || die

	# remove documentation installation target because it's just dirty
	sed -i -e '/LICENSE)$/,/README)$/d' makefile || die "failed to fix bad documentation installation target"
}

src_install() {
	# install_lib_dir requires a terminating slash because of a bug in libcutl's makefiles
	emake verbose=1 install_prefix="${D}/usr" install_lib_dir="${D}/usr/$(get_libdir)/" \
		install || die

	dodoc README NEWS TODO || die
}

src_test() {
	# dev-util/build doesn't use libtool, so we have to specify the -rpath
	# for tests with LD_LIBRARY_PATH to avoid polluting the installed
	# libcutl.so with extraneous -rpaths (I think...)
	LD_LIBRARY_PATH="${S}/cutl:${LD_LIBRARY_PATH}" emake test || die
}