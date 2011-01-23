# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit cmake-utils

DESCRIPTION="Drivers and libraries for the Xbox Kinect device"
HOMEPAGE="https://github.com/OpenKinect/libfreenect"
SRC_URI="http://ompldr.org/vNzQ5bg/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/libusb:1
	media-libs/freeglut"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_install() {
	cmake-utils_src_install
	insinto /$(get_libdir)/udev/rules.d/
	doins "${FILESDIR}/51-kinect.rules" || die
}

pkg_postinst() {
	elog "Make sure your user is in the 'video' group"
	elog "Just run 'gpasswd -a <USER> video', then have <USER> re-login."
}
