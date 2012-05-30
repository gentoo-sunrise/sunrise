# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
PYTHON_DEPEND="python? 2:2.6"

inherit cmake-utils multilib python

DESCRIPTION="Drivers and libraries for the Xbox Kinect device"
HOMEPAGE="https://github.com/OpenKinect/libfreenect"
SRC_URI="https://github.com/OpenKinect/${PN}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="c_sync examples fakenect opencv python"
REQUIRED_USE="opencv? ( c_sync )
	python? ( c_sync )"

RDEPEND="virtual/libusb:1
	examples? (
		media-libs/freeglut
		virtual/opengl
	)
	opencv? ( media-libs/opencv )
	python? (
		dev-python/numpy
		>=dev-python/cython-0.14.1-r1
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_unpack() {
	unpack ${A}
	mv OpenKinect-${PN}-* ${P} || die
}

pkg_setup() {
	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build c_sync)
		$(cmake-utils_use_build examples)
		$(cmake-utils_use_build examples CPP)
		$(cmake-utils_use_build fakenect)
		$(cmake-utils_use_build opencv CV)
		$(cmake-utils_use_build python)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	# Rename record example so it does not collide with xawtv
	if use examples && use fakenect; then
		mv "${D}"/usr/bin/record "${D}"/usr/bin/frecord || die
	fi
	# Remove cvdemo if examples is not enabled
	if use opencv && ! use examples; then
		rm -f "${D}"/usr/bin/cvdemo || die
	fi
	insinto /$(get_libdir)/udev/rules.d/
	doins "${FILESDIR}/51-kinect.rules"
}

pkg_postinst() {
	elog "Make sure your user is in the 'video' group"
	elog "Just run 'gpasswd -a <USER> video', then have <USER> re-login."
}
