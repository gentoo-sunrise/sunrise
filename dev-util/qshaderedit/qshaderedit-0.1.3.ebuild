# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cmake-utils

DESCRIPTION="A simple multiplatform shader editor inspired by Apple's OpenGL Shader Builder"
HOMEPAGE="http://code.google.com/p/qshaderedit/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="x11-libs/qt-gui
	x11-libs/qt-opengl
	 media-libs/glew"
RDEPEND=${DEPEND}

S=${WORKDIR}/${PN}
