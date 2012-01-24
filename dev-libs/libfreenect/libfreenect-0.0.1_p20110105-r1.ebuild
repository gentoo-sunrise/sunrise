# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="python? 2:2.6"

inherit cmake-utils multilib python

DESCRIPTION="Drivers and libraries for the Xbox Kinect device"
HOMEPAGE="https://github.com/OpenKinect/libfreenect"
SRC_URI="http://ompldr.org/vNzQ5bg/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples fakenect c_sync opencv python"

RDEPEND="dev-libs/libusb:1
	examples? (
		media-libs/freeglut
		virtual/opengl
	)
	opencv? ( media-libs/opencv )
	python? ( dev-python/numpy )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

pkg_setup() {
	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build examples)
		$(cmake-utils_use_build fakenect)
		$(cmake-utils_use_build examples CPP)
		$(cmake-utils_use_build opencv CV)
		$(cmake-utils_use_build python)
	)
	# opencv & python requires c_sync
	if ! use c_sync && ( use opencv || use python ); then
		if use opencv; then
			local useflag="opencv"
		else
			local useflag="python"
		fi
		ewarn "${useflag} requires c synchronous support to be enabled; c_sync enabled"
	        mycmakeargs+=(
			-DBUILD_C_SYNC=ON
		)
	else
		mycmakeargs+=(
			$(cmake-utils_use_build c_sync)
		)
	fi
	if use python; then
		#Add numpy core include path in python CMakeList.txt to allow compilation
		sed -i -e "s|../c_sync/|$(python_get_sitedir)/numpy/core/include/ ../c_sync/|" "wrappers/python/CMakeLists.txt" || die
	fi
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	# Remove cvdemo if examples is not enabled
	if use opencv && ! use examples; then
		rm -f "${D}"/usr/bin/cvdemo || die
	fi
	insinto /$(get_libdir)/udev/rules.d/
	doins "${FILESDIR}/51-kinect.rules" || die
}

pkg_postinst() {
	elog "Make sure your user is in the 'video' group"
	elog "Just run 'gpasswd -a <USER> video', then have <USER> re-login."
}
