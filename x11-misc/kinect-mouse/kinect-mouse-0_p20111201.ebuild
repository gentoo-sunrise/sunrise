# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit cmake-utils

DESCRIPTION="A program that uses the libfreenect drivers to control mouse input"
HOMEPAGE="https://github.com/Ooblik/Kinect-Mouse"
SRC_URI="http://ompldr.org/vY2ZuMQ/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/freeglut
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXtst
	dev-libs/libfreenect"
RDEPEND="${DEPEND}"

pkg_postinst() {
	elog "To start using the kinect as a mouse, execute the kmouse program."
	elog "The kmouse program performs a left click when you hold the "
	elog "cursor over something for a few seconds."
}
